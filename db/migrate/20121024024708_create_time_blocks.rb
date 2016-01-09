class CreateTimeBlocks < ActiveRecord::Migration
  def change
    create_table :time_blocks do |t|
      t.integer :user_id
      t.time :start_time
      t.time :end_time
      t.integer :day_of_week

      t.timestamps
    end
  end
end
