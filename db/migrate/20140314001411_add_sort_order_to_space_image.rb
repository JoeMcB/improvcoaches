class AddSortOrderToSpaceImage < ActiveRecord::Migration
  def change
    add_column :space_images, :sort_order, :integer
  end
end
