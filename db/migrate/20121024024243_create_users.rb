class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.boolean :is_coach
      t.text :bio
      t.string :password_digest

      t.timestamps
    end
  end
end
