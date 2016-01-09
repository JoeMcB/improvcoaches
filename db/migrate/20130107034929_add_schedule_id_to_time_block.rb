class AddScheduleIdToTimeBlock < ActiveRecord::Migration
  def change
    add_column :time_blocks, :schedule_id, :integer
  end
end
