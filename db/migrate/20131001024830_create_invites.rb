class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.string :code
      t.integer :owner_id
      t.string :recipient
      t.string :status

      t.timestamps
    end
  end
end
