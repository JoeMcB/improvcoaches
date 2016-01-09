class CreateSpaceImages < ActiveRecord::Migration
  def change
    create_table :space_images do |t|
      t.integer :space_id

      t.timestamps
    end
  end
end
