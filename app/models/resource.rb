class Resource < ActiveRecord::Base
  attr_accessible :amazon_id, :image_url, :long_description, :name, :price, :resource_type, :short_description, :url

  validates :name, :url, :long_description, presence: true
  validates :resource_type, inclusion: { in: %w(book dvd website resource)}
  validates :price, numericality: true, if: -> { resource_type != 'website'}

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  def self.create_from_amazon_id(amazon_id, short_description = nil)
    item = AmazonItem.new(amazon_id)
    if item.success?
      Resource.create(
        amazon_id: amazon_id,
        name: item.title,
        url: item.url,
        image_url: item.image('large'),
        price: item.price,
        long_description: item.description,
        short_description: short_description,
        resource_type: item.item_type
      )
    else
      Resource.new.errors.add(:base, "Could not find a product with amazon id #{amazon_id}")
    end
  end

end
