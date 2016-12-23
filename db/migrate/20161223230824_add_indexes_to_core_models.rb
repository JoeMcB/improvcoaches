class AddIndexesToCoreModels < ActiveRecord::Migration
  def change
  	add_index :time_blocks, :schedule_id
  	add_index :schedules, :user_id
  	add_index :experiences, :user_id
  	add_index :invites, :owner_id
  	add_index :invites, :code
  end
end
