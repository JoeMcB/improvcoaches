class AddSlugToSpaces < ActiveRecord::Migration
  def change
  	add_column :spaces, :slug, :string
    add_index :spaces, :slug
  end
end
