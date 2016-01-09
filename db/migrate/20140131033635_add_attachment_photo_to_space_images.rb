class AddAttachmentPhotoToSpaceImages < ActiveRecord::Migration
  def self.up
    change_table :space_images do |t|
      t.attachment :photo
    end
  end

  def self.down
    drop_attached_file :space_images, :photo
  end
end
