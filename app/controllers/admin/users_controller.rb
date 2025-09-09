module Admin
  class UsersController < Admin::ApplicationController
    # Custom action to send password reset email
    def password_reset
      user = User.find(params[:id])
      user.send_password_reset
      flash[:notice] = "Password reset email sent to #{user.email}"
      redirect_to admin_user_path(user)
    end
    
    # Bulk actions
    def bulk_activate
      User.where(id: params[:user_ids]).update_all(is_active: true)
      flash[:notice] = "#{params[:user_ids].length} users activated"
      redirect_to admin_users_path
    end
    
    def bulk_deactivate
      User.where(id: params[:user_ids]).update_all(is_active: false)
      flash[:notice] = "#{params[:user_ids].length} users deactivated"
      redirect_to admin_users_path
    end
    
    # Export to CSV
    def export
      require 'csv'
      
      csv_data = CSV.generate(headers: true) do |csv|
        csv << ['ID', 'Name', 'Email', 'Active', 'Admin', 'Coach', 'City', 'Created At']
        
        scoped_resource.includes(:city).find_each do |user|
          csv << [
            user.id,
            user.name,
            user.email,
            user.is_active,
            user.is_admin == 1,
            user.is_coach,
            user.city&.name,
            user.created_at
          ]
        end
      end
      
      send_data csv_data, 
        filename: "users-#{Date.today}.csv",
        type: 'text/csv',
        disposition: 'attachment'
    end

    # Override to use friendly_id for finding users
    def find_resource(param)
      User.friendly.find(param)
    end
    
    # Override to add default ordering
    def scoped_resource
      super.order(created_at: :desc)
    end

    # Override to prevent editing sensitive fields
    def resource_params
      permitted = super
      # Remove sensitive fields that shouldn't be directly edited
      permitted.except(:password_digest, :auth_token, :password_reset_token, :oauth_token)
    end
  end
end
