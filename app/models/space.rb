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

  has_many :space_images
  belongs_to :city

  validates :name, presence: true, uniqueness: true

  
  def compiled_address
    "#{address} #{address_2}  #{real_city}  #{state} #{zip}"
  end
end
