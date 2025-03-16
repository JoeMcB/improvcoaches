# == Schema Information
#
# Table name: space_images
#
#  id                 :integer          not null, primary key
#  space_id           :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  sort_order         :integer
#

class SpaceImage < ActiveRecord::Base
  belongs_to :space
  
  # Active Storage attachment
  has_one_attached :image

  # Keep Paperclip for backward compatibility during migration
  has_attached_file :photo, 
  	styles: { thumb: "75x50#", small: "200x150#", medium: "400x300", large: "800x600#", xlarge: "1200x900#" }
  validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/
  validates_attachment_presence :photo, unless: -> { image.attached? }
  validates_attachment_size :photo, :less_than => 5.megabytes, unless: -> { image.attached? }
  
  # Active Storage validations
  validate :acceptable_image, if: -> { image.attached? }
  
  private
  
  def acceptable_image
    return unless image.attached?
    
    unless image.blob.content_type.start_with?('image/')
      errors.add(:image, 'must be an image')
    end
    
    unless image.blob.byte_size <= 5.megabytes
      errors.add(:image, 'is too big (maximum is 5MB)')
    end
  end
end
