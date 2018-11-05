class Space < ActiveRecord::Base
  extend FriendlyId

  has_many :space_images
  belongs_to :city

  #Friendly ID
  friendly_id :name, use: [:slugged, :history]

  validates :name, presence: true, uniqueness: true

  
  def compiled_address
    "#{address} #{address_2}  #{real_city}  #{state} #{zip}"
  end
end