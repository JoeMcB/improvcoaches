class HomeController < ApplicationController
  def index
  	@user_list = current_city.coaches.order("RANDOM()").limit(6)
  end

  def about
  end

  def become_a_coach
  end

  def splash
  	render layout: false
  end
end
