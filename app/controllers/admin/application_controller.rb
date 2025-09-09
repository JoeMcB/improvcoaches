# All Administrate controllers inherit from this
# `Administrate::ApplicationController`, making it the ideal place to put
# authentication logic or other before_actions.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    before_action :authenticate_admin
    before_action :log_admin_action
    helper_method :current_user
    
    rescue_from ActiveRecord::RecordNotFound do |e|
      flash[:error] = "Record not found"
      redirect_to admin_root_path
    end

    def authenticate_admin
      unless current_user&.is_admin?
        flash[:alert] = 'You must be an admin to access this area.'
        redirect_to root_path
      end
    end
    
    def log_admin_action
      # Log admin actions for auditing
      Rails.logger.info "Admin Action: #{current_user&.email} - #{controller_name}##{action_name} - #{request.ip}"
    end

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    def records_per_page
      params[:per_page] || 25
    end
    
    private
    
    def current_user
      @current_user ||= User.find_by(auth_token: cookies[:auth_token]) if cookies[:auth_token]
    end
  end
end
