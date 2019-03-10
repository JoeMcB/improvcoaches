# frozen_string_literal: true

class PasswordResetsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:email])
    user&.send_password_reset

    redirect_to root_url, notice: 'An email has been sent with a link to reset your password.'
  end

  def edit
    @user = User.find_by!(password_reset_token: params[:id])
  end

  def update
    @user = User.find_by!(password_reset_token: params[:id])

    if @user.password_reset_time < 2.hours.ago
      redirect_to new_password_reset_path, alert: 'Password reset link has expired.'
    elsif @user.update(params[:user].permit(:password, :password_confirmation))
      redirect_to login_path, notice: 'Your password has been updated.'
    else
      render :edit
    end
  end
end
