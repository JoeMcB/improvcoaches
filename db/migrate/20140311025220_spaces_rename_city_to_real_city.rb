class SpacesRenameCityToRealCity < ActiveRecord::Migration
  def up
  	rename_column :spaces, :city, :real_city
  end

  def down
  	rename_column :table, :city, :real_city
  end
end
