class InvitesController < ApplicationController
  before_filter :require_login, except: [:landing]

  def landing
    @invite = Invite.find_by_code(params[:code])

    if @invite.owner.city != current_city
      redirect_to subdomain: @invite.owner.city.subdomain
    else
      if @invite && @invite.status == 'pending'
        @user = User.new(params[:user]) # Hack till I figure out login
        session[:redirect_on_login] = invite_accept_url code: params[:code]

        flash.keep # Preserve to next request
      else
        redirect_to root_url, { flash: { alert: 'This invite has already been used.'} }
      end
    end
  end

  def invite_send
    to = params[:email]

    # Admins get free invites.
    current_user.add_invite if current_user.is_admin? && current_user.invites.free.count == 0

    if current_user.invites.free.count > 0
      if ValidatesEmailFormatOf.validate_email_format(to) == nil
        @invite = current_user.invites.free.first
        @invite.status = 'pending'
        @invite.recipient = to
        @invite.save!
        @invite.deliver

        @message = "#{to} has been invited to ImprovCoaches.  Thanks!"
        @level = 'success'
      else
        @message = "#{to} is not a valid email address."
        @level = 'danger'
      end
    else
      @message = 'You don\'t have any invites available.'
      @level = 'danger'
    end

    respond_to do |format|
      format.js
    end
  end
  

  def accept
    return_to_url = root_url
    @invite = Invite.find_by_code(params[:code])

    redirect_hash = { flash: {} }
    redirect_flash = redirect_hash[:flash]

    if @invite && @invite.status == 'pending'
      if !current_user.is_coach
        @invite.status = 'used'
        @invite.save!

        u = @user = User.find(current_user.id)

        u.is_coach = 't'
        u.is_improv = 't'
        u.city = @invite.owner.city
        u.save

        redirect_flash[:success] = 'Welcome to ImprovCoaches!  Be sure to add a bio, schedule, and your experience to help users discover your profile.'
      else
        redirect_flash[:alert] = 'Your account has already been upgraded.'
      end

      if @invite.owner.city != current_city
        return_to_url = profile_edit_url( subdomain: @invite.owner.city.subdomain )
      else
        return_to_url = profile_edit_url
      end
    else
      redirect_flash[:alert] = 'That invite has already been used.'
    end

    respond_to do |format|
      format.html { redirect_to return_to_url, redirect_hash }
    end
  end

  def resend
    @invite = Invite.find_by_code(params[:code])
    @invite.deliver

    respond_to do |format|
      format.js
    end
  end

  def cancel
    @invite = Invite.find_by_code(params[:code])
    if @invite.status != 'used'
      @invite.recipient = nil
      @invite.status = 'free'
      @invite.save!
    end

    respond_to do |format|
      format.js
    end
  end
end
