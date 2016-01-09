class CreateCitiesTheatresTable < ActiveRecord::Migration
  def up
  	create_table :cities_theatres, id: false do |t|
  		t.references :city
  		t.references :theatre
  	end

  	add_index :cities_theatres, [:city_id, :theatre_id]
  	add_index :cities_theatres, :city_id
  	add_index :cities_theatres, :theatre_id
  end

  def down
  	drop_table :cities_theatres
  end
end
