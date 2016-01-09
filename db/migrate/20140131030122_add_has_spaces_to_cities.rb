class AddHasSpacesToCities < ActiveRecord::Migration
  def change
    add_column :cities, :has_spaces, :boolean
  end
end
