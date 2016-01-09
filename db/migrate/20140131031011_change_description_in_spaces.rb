class ChangeDescriptionInSpaces < ActiveRecord::Migration
   def self.up
   change_column :spaces, :description, :text
  end

  def self.down
   change_column :spaces, :description, :string
  end
end
