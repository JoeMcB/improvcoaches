class RemoveDayOfWeekFromTimeBlocks < ActiveRecord::Migration
   def up
    remove_column :time_blocks, :day_of_week
  end
 
  def down
    add_column :time_blocks, :day_of_week, :integer
  end
end
