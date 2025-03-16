# == Schema Information
#
# Table name: space_images
#
#  id                 :integer          not null, primary key
#  space_id           :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  sort_order         :integer
#

class SpaceImage < ActiveRecord::Base
  belongs_to :space
  
  # Active Storage attachment
  has_one_attached :image
  
  # Validations
  validates :image, presence: true
  validate :acceptable_image, if: -> { image.attached? }
  
  # Variant helpers for different image sizes
  def thumb
    image.variant(resize_to_fill: [75, 50])
  end
  
  def small
    image.variant(resize_to_fill: [200, 150])
  end
  
  def medium
    image.variant(resize_to_fit: [400, 300])
  end
  
  def large
    image.variant(resize_to_fill: [800, 600])
  end
  
  def xlarge
    image.variant(resize_to_fill: [1200, 900])
  end
  
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
