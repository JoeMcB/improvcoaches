# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :current_user

  helper_method :current_user
  helper_method :current_city
  helper_method :process_uri

  protected

  def authenticate
    # authenticate_or_request_with_http_basic do |username, password|
    #   if(username == "beta" && password == "followthefear")
    #     true
    #   else
    #     request_http_basic_authentication
    #   end
    # end if Rails.env.production?
  end

  private

  def process_uri(uri)
    require 'open-uri'
    require 'open_uri_redirections'

    open(uri, allow_redirections: :safe) do |r|
      r.base_uri.to_s
    end
  end

  def current_user
    @current_user ||= User.find_by(auth_token: cookies[:auth_token]) if cookies[:auth_token]
  end

  def current_city
    @current_city = @current_city || City.find_by(subdomain: request.subdomain) || City.find_by_name("New York") || City.first
  end

  def require_login
    if current_user.nil?
      respond_to do |format|
        format.html do
          session[:return_to] = request.url
          redirect_to root_url, alert: 'Please log in to access that page.'
        end

        format.js do
          render 'shared/_alert', locals: { level: 'info', message: 'Please log in to access that page.' }
        end
      end
    end
  end

  def require_admin
    unless current_user&.is_admin?
      respond_to do |format|
        format.html do
          session[:return_to] = request.url
          redirect_to root_url, alert: 'You are not authorized to view that page.'
        end

        format.js do
          render 'shared/_alert', locals: { level: 'info', message: 'You are not authorized to view that page.' }
        end
      end
    end
  end

  def require_owner_or_admin
    unless current_user.id == params[:id] || current_user.is_admin?
      session[:return_to] = request.url
      redirect_to login_url, alert: 'Please log in to perform that action.'
    end
  end

  def set_authorized_user(user, remember_me)
    if remember_me
      cookies.permanent[:auth_token] = user.auth_token
    else
      cookies[:auth_token] = user.auth_token
    end
  end

  def remove_authorized_user
    cookies.delete(:auth_token)
  end
end
