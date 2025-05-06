class RemovePaperclipColumns < ActiveRecord::Migration[6.1]
  def up
    remove_column :space_images, :photo_file_name
    remove_column :space_images, :photo_content_type
    remove_column :space_images, :photo_file_size
    remove_column :space_images, :photo_updated_at
  end
  
  def down
    add_column :space_images, :photo_file_name, :string
    add_column :space_images, :photo_content_type, :string
    add_column :space_images, :photo_file_size, :integer
    add_column :space_images, :photo_updated_at, :datetime
  end
end
