class UpdateStartTimeEndTimeFromTimeBlocks < ActiveRecord::Migration
  def up
  	change_table :time_blocks do |t|
  		t.remove :start_time, :end_time
  		t.integer :day
  		t.integer :hour
  		t.integer :minute
  	end
  end

  def down
  	change_table :time_blocks do |t|
  		t.time :start_time
  		t.time :end_time
  		t.remove :day
  		t.remove :hour
  		t.remove :minute
  	end
  end

end
