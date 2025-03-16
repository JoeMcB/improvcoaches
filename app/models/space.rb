# == Schema Information
#
# Table name: spaces
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  description    :text
#  city_id        :integer
#  rating         :decimal(, )
#  website_link   :string(255)
#  yelp_link      :string(255)
#  facebook_link  :string(255)
#  address        :string(255)
#  address_2      :string(255)
#  zip            :string(255)
#  real_city      :string(255)
#  state          :string(255)
#  phone          :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  slug           :string(255)
#  is_rehearsal   :boolean          default(TRUE)
#  is_performance :boolean          default(FALSE)
#  email          :string(255)
#

class Space < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:history]

  has_many :space_images, dependent: :destroy
  belongs_to :city

  validates :name, presence: true, uniqueness: true

  def compiled_address
    "#{address} #{address_2}  #{real_city}  #{state} #{zip}"
  end
  
  # Helper method to get primary image
  def primary_image
    space_images.order(:sort_order).first
  end
  
  # Helper methods for Active Storage variants
  def image_thumb
    primary_image&.image&.variant(resize_to_fill: [75, 50])
  end
  
  def image_small
    primary_image&.image&.variant(resize_to_fill: [200, 150])
  end
  
  def image_medium
    primary_image&.image&.variant(resize_to_fit: [400, 300])
  end
  
  def image_large
    primary_image&.image&.variant(resize_to_fill: [800, 600])
  end
  
  def image_xlarge
    primary_image&.image&.variant(resize_to_fill: [1200, 900])
  end
end
