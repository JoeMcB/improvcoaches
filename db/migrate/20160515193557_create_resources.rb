class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.string :name
      t.string :short_description
      t.text :long_description
      t.string :amazon_id
      t.string :url
      t.string :image_url
      t.string :resource_type
      t.decimal :price
      t.string :slug

      t.timestamps
    end
  end
end
