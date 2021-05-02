# frozen_string_literal: true

class AuthController < ApplicationController
  def new; end

  def link
    @email = session[:omniauth][:info][:email] if session[:omniauth]
  end

  def confirm_link
    auth = session[:omniauth]
    user = User.find_by_email auth[:info][:email].downcase
    return_url = session.delete(:redirect_on_login) || :back

    if !(user && user.authenticate(params[:password]))
      user.provider = auth.provider
      user.uid = auth.uid
      user.oauth_token = auth.credentials.token
      user.oauth_token_expires_at = Time.at(auth.credentials.expires_at)

      if user.save
        set_authorized_user(user, true)

        respond_to do |format|
          format.html { redirect_to return_url, flash: { notice: 'Your Facebook account has been linked.' } }
          format.js { render partial: 'create' }
        end
      else
        respond_to do |format|
          format.html { redirect_to return_url, flash: { error: 'Your Facebook account could not be linked.' } }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to link_path, flash: { warning: 'Hmm, that email and password appear to be invalid.' } }
      end
    end
  end

  def create
    return_url = session.delete(:redirect_on_login) || :back

    if params['from_facebook']
      auth = request.env['omniauth.auth']

      if User.where(email: auth.info.email.downcase, provider: nil).first
        session[:omniauth] = auth.except('extra')
        respond_to do |format|
          format.html { redirect_to link_path, flash: { notice: 'We already have an account for that email.  You can link your accounts below.' } }
          format.js { render partial: 'create' }
        end
      else
        uid = auth['uid']
        provider = auth['provider']
        puts auth.inspect
        User.where(uid: uid, provider: provider).first_or_initialize.tap do |user|
          if user.id.nil?
            user.provider = auth.provider
            user.uid = auth.uid
            user.name = auth.info.name
            user.avatar = URI.parse(process_uri("http://graph.facebook.com/v10.0/#{auth.uid}/picture?height=500&width=500"))
            user.email = auth.info.email
            user.password_digest = SecureRandom.urlsafe_base64
          end

          user.oauth_token = auth.credentials.token
          user.oauth_token_expires_at = Time.at(auth.credentials.expires_at)

          if !user.save
            session[:omniauth] = auth.except('extra')
            # action = { action: :link } #this is here because it was throwing an error down there (?)
            redirect_to return_url, flash: { notice: 'Welp, no one should ever see this.  Email support if you do!' }
            return false
          else
            set_authorized_user(user, true)

            if params[:invite_code]
              redirect_to invite_accept_url(code: params[:invite_code])
            else
              respond_to do |format|
                format.html { redirect_to return_url, flash: { success: "Welcome back #{user.name}" } }
                format.js { render partial: 'create' }
              end
            end
          end
        end
      end
    else
      user = User.find_by_email(params[:email].downcase)
      unless user.nil?
        if !(user && user.authenticate(params[:password]))
          respond_to do |format|
            format.html { redirect_to login_url, flash: { notice: 'Hmm, that email and password appear to be invalid.' } }
            format.js { render partial: 'create' }
          end
        else
          set_authorized_user(user, params[:remember_me])

          if params[:invite_code]
            session[:redirect_on_login] = invite_accept_url(code: params[:invite_code])
          else
            respond_to do |format|
              format.html { redirect_to return_url, flash: { success: "Welcome back #{user.name}" } }
              format.js { render partial: 'create' }
            end
          end
        end
      end
    end
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end

  def destroy
    return_url = session.delete(:redirect_on_login) || :back
    remove_authorized_user
    redirect_to return_url, notice: 'You have been logged out.  See ya!'
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end

  def failure
    return_url = session.delete(:redirect_on_login) || :back
    message = params[:message] || ''
    redirect_to return_url, flash: { notice: "There was an error logging you in via Facebook: #{message} " }
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end
end
