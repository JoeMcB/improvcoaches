class CreateSpaces < ActiveRecord::Migration
  def change
    create_table :spaces do |t|
      t.string :name
      t.text :description
      t.integer :city_id
      t.decimal :rating
      t.string :website_link
      t.string :yelp_link
      t.string :facebook_link
      t.string :address
      t.string :address_2
      t.string :zip
      t.string :city
      t.string :state
      t.string :phone

      t.timestamps
    end
  end
end
