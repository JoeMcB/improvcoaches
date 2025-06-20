# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  email                  :string(255)
#  is_coach               :boolean
#  bio                    :text
#  password_digest        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  img                    :string(255)
#  rate                   :integer
#  last_updated           :datetime
#  is_admin               :integer
#  avatar_file_name       :string(255)
#  avatar_content_type    :string(255)
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#  auth_token             :string(255)
#  password_reset_token   :string(255)
#  password_reset_time    :datetime
#  rating                 :integer
#  uid                    :string(255)
#  oauth_token            :string(255)
#  oauth_token_expires_at :datetime
#  provider               :string(255)
#  slug                   :string(255)
#  invite_id              :integer
#  is_active              :boolean
#  is_sketch              :boolean
#  is_improv              :boolean
#  city_id                :integer
#

class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, email_format: { message: 'is not a valid email.' }

  # Old recommendation system, removed for local editing.
  recommends :users
  after_like ->(u) { u.update_rating }
  after_dislike ->(u) { u.update_rating }

  has_secure_password

  # Active Storage Image
  has_one_attached :avatar

  # Avatar variant helpers
  def avatar_large
    avatar.variant(resize_to_fill: [500, 500])
  end

  def avatar_medium
    avatar.variant(resize_to_fill: [300, 300])
  end

  def avatar_small
    avatar.variant(resize_to_fill: [100, 100])
  end

  def avatar_thumb
    avatar.variant(resize_to_fill: [50, 50])
  end

  # Avatar validation - only run when avatar is being changed
  validate :acceptable_avatar, if: -> { avatar.attached? && avatar.changed_for_autosave? }

  def acceptable_avatar
    return unless avatar.attached?

    unless avatar.blob.content_type.start_with?('image/')
      errors.add(:avatar, 'must be an image')
    end

    # Removed 5MB file size restriction
  end

  has_one :schedule, dependent: :destroy
  has_many :experiences, dependent: :destroy
  has_many :theatres, -> { distinct }, through: :experiences
  has_many :invites, foreign_key: :owner_id
  belongs_to :invite, optional: true
  belongs_to :city, optional: true

  before_create :defaults, :generate_auth_token, :create_schedule, :lowercase_email

  scope :coaches, -> { where(is_coach: :t).where('is_improv = ? OR is_sketch = ?', true, true) }
  scope :improv_coaches, -> { coaches.where(is_improv: 't') }
  scope :sketch_coaches, -> { coaches.where(is_sketch: 't') }

  # Friendly ID
  friendly_id :name, use: %i[slugged history]

  # def should_generate_new_friendly_id?
  #  new_record?
  # end

  # Mail Actions
  def send_password_reset
    generate_token(:password_reset_token)
    update!(password_reset_time: Time.now)
    UserMailer.password_reset(self).deliver_now
  end

  def send_coach_contact(to, body)
    UserMailer.coach_contact(self, to, body).deliver_now
  end

  def send_comment_notification(comment_data)
    UserMailer.comment_notification(self, comment_data['from']['name'], comment_data['message']).deliver_now
  end

  # Utility
  def to_s
    name
  end

  # invite Funcitons
  def add_invite
    Invite.create do |i|
      i.owner = self
    end
  end

  # Rating Functions
  def total_ratings
    (liked_by_count || 0) + (disliked_by_count || 0)
  end

  def calculate_rating
    total_ratings > 0 ? (((liked_by_count || 0).to_f / total_ratings.to_f) * 100) : -1
  end

  def update_rating
    self.rating = calculate_rating
    save
  end

  # END Rating Function

  def has_experience?(theatre_id, experience_type_id)
    !experiences.where(theatre_id: theatre_id, experience_type_id: experience_type_id).empty?
  end

  def unlink!
    update!(
      uid: nil,
      provider: nil,
      oauth_token: nil,
      oauth_token_expires_at: nil
    )
  end

  private

  def defaults
    self.bio ||= ''
    self.is_coach ||= 'f'
    self.is_active ||= 't'
    self.is_improv ||= 't'
    self.is_sketch ||= 'f'
    self.is_admin ||= 'f'
    self.rating = -1
  end

  def generate_auth_token
    generate_token(:auth_token)
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def create_schedule
    self.schedule = Schedule.new
  end

  def lowercase_email
    email.downcase!
  end
end
