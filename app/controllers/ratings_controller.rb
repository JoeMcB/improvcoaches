class RatingsController < ApplicationController
  before_filter :require_login
  def like
    @user = User.find(params[:user_id])
    current_user.like @user

    respond_to do |format|

      format.html { redirect_to user_path(@user), notice: 'Liked!' }
      format.js { render partial: 'liked_or_disliked' }
    end
  end

  def dislike
    @user = User.find(params[:user_id])
    current_user.dislike @user

    respond_to do |format|
      format.html { redirect_to user_path(@user), notice: 'Disliked!' }
      format.js { render partial: 'liked_or_disliked' }
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
