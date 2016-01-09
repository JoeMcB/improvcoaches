class AddEmailToSpaces < ActiveRecord::Migration
  def change
    add_column :spaces, :email, :string
  end
end
