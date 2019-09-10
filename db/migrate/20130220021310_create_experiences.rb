class CreateExperiences < ActiveRecord::Migration
  def change
  	#drop_table :experiences
  	
    create_table :experiences do |t|
      t.integer :theatre_id
      t.integer :user_id
      t.integer :experience_type_id

      t.timestamps
    end
  end
end
