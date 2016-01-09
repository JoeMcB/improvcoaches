class AddRatingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :rating, :integer

    User.all.each do |user|
  		user.rating = user.calculate_rating
  		user.save
  	end
  end
end
