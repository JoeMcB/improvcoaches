require "administrate/base_dashboard"
require "administrate/field/active_storage"

class UserDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  ATTRIBUTE_TYPES = {
    # Core Identity Fields
    id: Field::Number,
    name: Field::String.with_options(searchable: true),
    email: Field::String.with_options(searchable: true),
    slug: Field::String.with_options(searchable: false),
    avatar: Field::ActiveStorage.with_options(
      destroy_path: proc do |_namespace, _resource, attachment|
        [:admin, attachment.record, attachment.name, { attachment_id: attachment.id }]
      end
    ),
    
    # Role & Status Fields
    is_active: Field::Boolean,
    is_admin: Field::Boolean.with_options(
      true_value: 1,
      false_value: 0
    ),
    is_coach: Field::Boolean,
    is_improv: Field::Boolean,
    is_sketch: Field::Boolean,
    
    # Profile Fields
    bio: Field::Text,
    city: Field::BelongsTo,
    rate: Field::Number,
    rating: Field::Number.with_options(suffix: "%"),
    
    # Associations
    experiences: Field::HasMany,
    invites: Field::HasMany,
    invite: Field::BelongsTo,
    schedule: Field::HasOne,
    theatres: Field::HasMany,
    
    # Authentication & Security
    password_reset: Field::PasswordReset,
    provider: Field::String,
    uid: Field::String.with_options(searchable: false),
    
    # Timestamps
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    last_updated: Field::DateTime,
    password_reset_time: Field::DateTime,
    
    # Sensitive fields (hidden from forms)
    auth_token: Field::String.with_options(searchable: false),
    password_digest: Field::String.with_options(searchable: false),
    password_reset_token: Field::String.with_options(searchable: false),
    oauth_token: Field::String.with_options(searchable: false),
    oauth_token_expires_at: Field::DateTime,
    
    # Legacy fields
    img: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # Displayed on the index page
  COLLECTION_ATTRIBUTES = %i[
    id
    name
    email
    is_active
    is_admin
    is_coach
    created_at
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # Displayed on the show page
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    name
    email
    slug
    avatar
    
    is_active
    is_admin
    is_coach
    is_improv
    is_sketch
    
    bio
    city
    rate
    rating
    
    password_reset
    
    experiences
    invites
    invite
    schedule
    theatres
    
    provider
    uid
    
    created_at
    updated_at
    last_updated
    password_reset_time
  ].freeze

  # FORM_ATTRIBUTES
  # Displayed on new/edit forms
  FORM_ATTRIBUTES = %i[
    name
    email
    avatar
    
    is_active
    is_admin
    is_coach
    is_improv
    is_sketch
    
    bio
    city
    rate
    
    invite
  ].freeze

  # COLLECTION_FILTERS
  # Filters available in the search
  COLLECTION_FILTERS = {
    active: ->(resources) { resources.where(is_active: true) },
    inactive: ->(resources) { resources.where(is_active: false) },
    admin: ->(resources) { resources.where(is_admin: 1) },
    coach: ->(resources) { resources.where(is_coach: true) },
    with_avatar: ->(resources) { resources.joins(:avatar_attachment) },
    facebook: ->(resources) { resources.where.not(provider: nil) }
  }.freeze

  # Customize how users are displayed
  def display_resource(user)
    user.name.presence || "User ##{user.id}"
  end
end