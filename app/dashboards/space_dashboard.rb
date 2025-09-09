require "administrate/base_dashboard"

class SpaceDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    name: Field::String.with_options(searchable: true),
    slug: Field::String.with_options(searchable: false),
    
    # Location
    address: Field::String,
    address_2: Field::String,
    city: Field::BelongsTo,
    real_city: Field::String,
    state: Field::String,
    zip: Field::String,
    
    # Details
    description: Field::Text,
    is_performance: Field::Boolean,
    is_rehearsal: Field::Boolean,
    rating: Field::String.with_options(searchable: false),
    
    # Contact
    email: Field::String,
    phone: Field::String,
    website_link: Field::String,
    facebook_link: Field::String,
    yelp_link: Field::String,
    
    # Associations
    space_images: Field::HasMany,
    
    # Timestamps
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  COLLECTION_ATTRIBUTES = %i[
    id
    name
    city
    is_performance
    is_rehearsal
    created_at
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    name
    slug
    
    address
    address_2
    city
    real_city
    state
    zip
    
    description
    is_performance
    is_rehearsal
    rating
    
    email
    phone
    website_link
    facebook_link
    yelp_link
    
    space_images
    
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    name
    
    address
    address_2
    city
    real_city
    state
    zip
    
    description
    is_performance
    is_rehearsal
    
    email
    phone
    website_link
    facebook_link
    yelp_link
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  COLLECTION_FILTERS = {
    performance: ->(resources) { resources.where(is_performance: true) },
    rehearsal: ->(resources) { resources.where(is_rehearsal: true) },
    with_images: ->(resources) { resources.joins(:space_images).distinct }
  }.freeze

  # Overwrite this method to customize how spaces are displayed
  # across all pages of the admin dashboard.
  def display_resource(space)
    space.name || "Space ##{space.id}"
  end
end