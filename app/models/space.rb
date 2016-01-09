class Space < ActiveRecord::Base
  extend FriendlyId

  attr_accessible :address, :address_2, :real_city, :city_id, :description, :facebook_link, :name, :phone, :rating, :state, :website_link, :yelp_link, :zip, :is_rehearsal, :is_performance, :email

  has_many :space_images
  belongs_to :city

  #Friendly ID
  friendly_id :name, use: [:slugged, :history]

  validates :name, presence: true, uniqueness: true

  
  def compiled_address
    "#{address} #{address_2}  #{real_city}  #{state} #{zip}"
  end
end