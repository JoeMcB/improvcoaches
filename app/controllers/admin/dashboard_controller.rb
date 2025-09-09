module Admin
  class DashboardController < Admin::ApplicationController
    def index
      @total_users = User.count
      @active_users = User.where(is_active: true).count
      @coaches = User.where(is_coach: true).count
      @recent_users = User.order(created_at: :desc).limit(10)
      
      # Simple monthly breakdown for last 6 months
      @users_by_month = {}
      6.times do |i|
        month = (Date.today - i.months).beginning_of_month
        month_name = month.strftime("%b %Y")
        @users_by_month[month_name] = User.where(
          created_at: month.beginning_of_month..month.end_of_month
        ).count
      end
      @users_by_month = @users_by_month.to_a.reverse.to_h
      
      # Users by city
      @users_by_city = User.joins(:city)
                           .group('cities.name')
                           .count
                           .sort_by(&:last)
                           .reverse
                           .first(10)
      
      # Activity metrics
      @recent_signups = User.where('created_at > ?', 7.days.ago).count
      @facebook_users = User.where.not(provider: nil).count
      
      # Count users with avatars - handle Active Storage properly
      @users_with_avatars = User.joins(
        "LEFT JOIN active_storage_attachments ON active_storage_attachments.record_id = users.id 
         AND active_storage_attachments.record_type = 'User' 
         AND active_storage_attachments.name = 'avatar'"
      ).where.not(active_storage_attachments: { id: nil }).count
      
      # Experience metrics
      @total_experiences = Experience.count
      @total_theatres = Theatre.count
      @total_spaces = Space.count
    rescue => e
      Rails.logger.error "Dashboard error: #{e.message}"
      # Provide default values if there's an error
      @users_by_month = {}
      @users_by_city = []
      @users_with_avatars = 0
    end
  end
end