class AddPrimaryTheatreIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :theatre_id, :integer
  end
end
