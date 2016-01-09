class RemoveUserIdFromTimeBlock < ActiveRecord::Migration
  def up
    remove_column :time_blocks, :user_id
  end

  def down
    add_column :time_blocks, :user_id, :integer
  end
end
