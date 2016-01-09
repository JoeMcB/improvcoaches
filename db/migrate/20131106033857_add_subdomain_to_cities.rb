class AddSubdomainToCities < ActiveRecord::Migration
  def change
    add_column :cities, :subdomain, :string
  end
end
