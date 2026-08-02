# frozen_string_literal: true

require "open-uri"

class AuthController < ApplicationController
  def new; end

  def link
    @email = session[:omniauth][:info][:email] if session[:omniauth]
  end

  def confirm_link
    auth = session[:omniauth]
    user = User.find_by_email(auth&.dig(:info, :email).to_s.downcase)

    if user&.authenticate(params[:password])
      expires_at = auth.dig(:credentials, :expires_at)
      user.assign_attributes(
        provider: auth[:provider],
        uid: auth[:uid],
        oauth_token: auth[:credentials][:token],
        oauth_token_expires_at: expires_at && Time.at(expires_at)
      )

      if user.save
        set_authorized_user(user, true)
        flash[:notice] = 'Your Facebook account has been linked.'
        return_url = session.delete(:return_to) || root_path
        redirect_to return_url
      else
        flash[:error] = 'Your Facebook account could not be linked.'
        return_url = session.delete(:return_to) || root_path
        redirect_to return_url
      end
    else
      flash[:warning] = 'Hmm, that email and password appear to be invalid.'
      redirect_to link_path
    end
  end

  def create
    if params['from_facebook']
      auth = request.env['omniauth.auth']
      if auth.blank? || auth.info.email.blank?
        redirect_to login_path, alert: 'Facebook did not provide the account information needed to log in.'
        return
      end

      if User.where(email: auth.info.email.downcase, provider: nil).first
        session[:omniauth] = auth.except('extra')
        flash[:notice] = 'We already have an account for that email. You can link your accounts below.'
        redirect_to link_path
      else
        user = User.where(uid: auth['uid'], provider: auth['provider']).first_or_initialize
        setup_new_user(user, auth) unless user.persisted?

        if user.save
          set_authorized_user(user, true)
          redirect_to_next_step(user, params[:invite_code])
        else
          session[:omniauth] = auth.except('extra')
          flash[:notice] = 'Welp, no one should ever see this. Email support if you do!'
          return_url = session.delete(:return_to) || root_path
          redirect_to return_url
        end
      end
    else
      user = User.find_by_email(params[:email].to_s.downcase)
      handle_existing_user(user, params)
    end
  end

  def destroy
    remove_authorized_user
    flash[:notice] = 'You have been logged out. See ya!'
    redirect_back(fallback_location: login_url)
  end

  def failure
    flash[:notice] = "There was an error logging you in via Facebook: #{params[:message] || ''}"
    redirect_back(fallback_location: login_url)
  end

  private

  def setup_new_user(user, auth)
    avatar_io = fetch_facebook_avatar(auth.uid)
  rescue StandardError => error
    Rails.logger.warn("Facebook avatar download failed: #{error.class}: #{error.message}")
    assign_facebook_user_attributes(user, auth, nil)
  else
    assign_facebook_user_attributes(user, auth, avatar_io)
  end

  def assign_facebook_user_attributes(user, auth, avatar_io)
    attributes = {
      provider: auth.provider,
      uid: auth.uid,
      name: auth.info.name,
      email: auth.info.email,
      password: SecureRandom.urlsafe_base64(32),
      oauth_token: auth.credentials.token,
      oauth_token_expires_at: auth.credentials.expires_at && Time.at(auth.credentials.expires_at)
    }
    if avatar_io
      attributes[:avatar] = {
        io: avatar_io,
        filename: "facebook-avatar-#{auth.uid}.jpg",
        content_type: avatar_io.respond_to?(:content_type) ? avatar_io.content_type : "image/jpeg"
      }
    end

    user.attributes = attributes
  end

  def fetch_facebook_avatar(uid)
    URI.open("https://graph.facebook.com/v24.0/#{uid}/picture?height=500&width=500")
  end

  def redirect_to_next_step(user, invite_code)
    if invite_code
      session.delete(:return_to)
      redirect_to invite_landing_url(code: invite_code), flash: { success: "Welcome back #{user.name}" }
    else
      flash[:success] = "Welcome back #{user.name}"
      return_url = session.delete(:return_to) || root_path
      redirect_to return_url
    end
  end

  def handle_existing_user(user, params)
    if user.nil? || !user.authenticate(params[:password])
      flash[:notice] = 'Hmm, that email and password appear to be invalid.'
      redirect_to login_url
    else
      set_authorized_user(user, params[:remember_me])
      redirect_to_next_step(user, params[:invite_code])
    end
  end
end
