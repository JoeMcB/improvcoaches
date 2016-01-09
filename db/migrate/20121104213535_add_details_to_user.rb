class AddDetailsToUser < ActiveRecord::Migration
  def change
    add_column :users, :img, :string
    add_column :users, :rate, :integer
    add_column :users, :last_updated, :timestamp
  end
end
