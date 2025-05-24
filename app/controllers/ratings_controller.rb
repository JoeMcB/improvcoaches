class RatingsController < ApplicationController
  before_action :require_login
  def like
    @user = User.find(params[:user_id])
    
    begin
      current_user.like @user
      @user.reload # Reload to get updated counts
    rescue => e
      Rails.logger.error "Like action failed: #{e.message}"
      # Fallback: just update rating without recommendable
      @user.update_rating
    end

    respond_to do |format|
      format.html { redirect_to user_path(@user), notice: 'Liked!' }
      format.js { render partial: 'liked_or_disliked' }
      format.turbo_stream
    end
  end

  def dislike
    @user = User.find(params[:user_id])
    
    begin
      current_user.dislike @user
      @user.reload # Reload to get updated counts
    rescue => e
      Rails.logger.error "Dislike action failed: #{e.message}"
      # Fallback: just update rating without recommendable
      @user.update_rating
    end

    respond_to do |format|
      format.html { redirect_to user_path(@user), notice: 'Disliked!' }
      format.js { render partial: 'liked_or_disliked' }
      format.turbo_stream
    end
  end

  def bookmark
    @user = User.find(params[:user_id])

    if(current_user.bookmarks? @user)
      current_user.unbookmark @user
      msg = "#{@user.name} removed from favorites."  
    else
      current_user.bookmark @user
      msg = "#{@user.name} added to favorites."  
    end

    respond_to do |format|
      format.html { redirect_to user_path(@user), notice: msg }
      format.js { render partial: 'bookmark' }
    end
  end
end
