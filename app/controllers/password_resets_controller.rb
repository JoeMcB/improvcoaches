# frozen_string_literal: true

class PasswordResetsController < ApplicationController
  def new; end

  def index
    # Redirect to new action - this ensures old links still work
    redirect_to new_password_reset_path
  end

  def create
    user = User.find_by(email: params[:email].to_s.downcase)
    user&.send_password_reset

    redirect_to root_url, notice: 'An email has been sent with a link to reset your password.'
  end

  def edit
    @user = User.find_by!(password_reset_token: params[:id])
    return unless password_reset_expired?(@user)

    redirect_to new_password_reset_path, alert: 'Password reset link has expired.'
  rescue ActiveRecord::RecordNotFound
    Rails.logger.error("Password reset failed for token: #{params[:id]}")
    # Show a user-friendly error
    redirect_to new_password_reset_path, alert: 'Password reset link is invalid or has expired. Please request a new one.'
  end

  def update
    @user = User.find_by!(password_reset_token: params[:id])

    if password_reset_expired?(@user)
      redirect_to new_password_reset_path, alert: 'Password reset link has expired.'
    elsif @user.update(password_params.merge(password_reset_token: nil, password_reset_time: nil))
      redirect_to login_path, notice: 'Your password has been updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    Rails.logger.error("Password reset update failed for token: #{params[:id]}")
    redirect_to new_password_reset_path, alert: 'Password reset link is invalid or has expired. Please request a new one.'
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def password_reset_expired?(user)
    user.password_reset_time.blank? || user.password_reset_time < 2.hours.ago
  end
end
