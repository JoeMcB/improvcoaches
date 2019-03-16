# frozen_string_literal: true

require 'open-uri'
require 'json'

class UsersController < ApplicationController
  before_action :require_login, only: %i[edit update edit_improv edit_schedule edit_endorsements edit_password delete_avatar email email_send invites unlink destroy]

  # GET /users
  # GET /users.json
  def index
    @users = current_city.coaches.joins(:schedule).order('schedules.updated_at desc').paginate(page: params[:page], per_page: 10)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  def register
    @user = User.new
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    if request.path != user_path(@user)
      redirect_to @user, status: :moved_permanently
    elsif @user&.is_coach && (@user&.is_improv || @user&.is_sketch)
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @user }
      end
    else
      redirect_to users_url, notice: "Sorry, we couldn't find that coach."
    end
  end

  def email
    @user = User.find(params[:user_id])
  end

  def email_send
    @to_user = User.find(params[:user_id])

    if current_user && @to_user
      current_user.send_coach_contact(@to_user, params[:message])
    end

    respond_to do |format|
      format.js
    end
  end

  def comment_send
    to_user = User.find(params[:user_id])
    comment_id = params[:comment_id]
    access_token = params[:access_token]

    comment_data = JSON.parse(open("https://graph.facebook.com/v2.4/#{comment_id}?access_token=#{access_token}").read)

    if comment_data['error'].nil?
      to_user.send_comment_notification(comment_data)
    end

    respond_to do |format|
      format.json { head :ok }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # Basic edit
  def edit; end

  def edit_improv
    @other_cities = Theatre.all - current_city.theatres
  end

  def edit_schedule; end

  def edit_endorsements; end

  def edit_password; end

  def delete_avatar; end

  def invites; end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user].permit(user_allowed_attributes << 'name'))

    if (!Rails.env.production? || verify_recaptcha(model: @user)) && @user.save
      set_authorized_user(@user, false)

      if params[:invite_code]
        redirect_to invite_accept_url(code: params[:invite_code])
      else
        respond_to do |format|
          format.html { redirect_to root_url, notice: 'Welcome to ImprovCoaches.com.' }
          format.json { render json: @user, status: :created, location: @user }
        end
      end
    else
      respond_to do |format|
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(current_user.id)
    updated = false

    # Are we updating experience?
    if params[:experience_update]
      @user.experiences.destroy_all # Remove all previous experience.

      unless params[:experience].nil?
        params[:experience].each do |theatre_id, experience_types|
          experience_types.each do |experience_type_id, _val|
            Experience.create!(
              theatre_id: theatre_id,
              experience_type_id: experience_type_id,
              user_id: @user.id
            )
          end
        end
        updated = true
      end
    else
      updated = @user.update(params[:user].permit(user_allowed_attributes))
    end

    respond_to do |format|
      if updated
        format.html { redirect_to request.referer, flash: { success: 'User was successfully updated.' } }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def unlink
    @user = current_user
    @user.unlink!
    @user.send_password_reset

    respond_to do |format|
      msg = "Your facebook account has been unlinked.  A password reset email has been sent to #{@user.email} to make sure you can still log in."
      format.html { redirect_to profile_edit_path, flash: { success: msg } }
    end
  end

  def destroy
    @user = current_user
    @user.destroy!
    remove_authorized_user

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def user_allowed_attributes
    %i[email avatar password password_confirmation is_improv is_sketch bio city_id]
  end
end
