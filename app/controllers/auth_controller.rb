# frozen_string_literal: true

class AuthController < ApplicationController
  def new; end

  def link
    @email = session[:omniauth][:info][:email] if session[:omniauth]
  end

  def confirm_link
    auth = session[:omniauth]
    user = User.find_by_email(auth[:info][:email].downcase)

    unless user && user.authenticate(params[:password])
      user.assign_attributes(
        provider: auth[:provider],
        uid: auth[:uid],
        oauth_token: auth[:credentials][:token],
        oauth_token_expires_at: Time.at(auth[:credentials][:expires_at])
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
      user = User.find_by_email(params[:email].downcase)
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
    user.attributes = {
      provider: auth.provider,
      uid: auth.uid,
      name: auth.info.name,
      email: auth.info.email,
      avatar: URI.parse(process_uri("http://graph.facebook.com/v10.0/#{auth.uid}/picture?height=500&width=500")),
      password_digest: SecureRandom.urlsafe_base64,
      oauth_token: auth.credentials.token,
      oauth_token_expires_at: Time.at(auth.credentials.expires_at)
    }
  end

  def redirect_to_next_step(user, invite_code)
    if invite_code
      redirect_to invite_accept_url(code: invite_code), flash: { success: "Welcome back #{user.name}" }
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
