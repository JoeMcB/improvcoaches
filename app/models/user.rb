class User < ActiveRecord::Base	
  extend FriendlyId

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, :email_format => {:message => 'is not a valid email.'}

  recommends :users
  after_like -> (u) { u.update_rating }
  after_dislike -> (u) { u.update_rating }

  has_secure_password
  has_attached_file :avatar,
  	styles: { 
  		large: "500x500#", medium: "300x300#", small: "100x100#", thumb: "50x50#"
  	},
  	default_style: :small,
    default_url: "/assets/users/missing_:style.png",
  	url: "/system/:class/:attachment/:id/:style/:basename.:extension",
    path: ":rails_root/public/system/:class/:attachment/:id/:style/:basename.:extension"
  
  has_one :schedule
  has_many :experiences
  has_many :theatres, -> { uniq }, through: :experiences
  has_many :invites, foreign_key: :owner_id
  belongs_to :invite
  belongs_to :city
  
  before_create :defaults, :generate_auth_token, :create_schedule, :lowercase_email
  
  scope :coaches, -> { where(is_coach: :t).where('is_improv = ? OR is_sketch = ?', true, true) }
  scope :improv_coaches, -> { coaches.where(is_improv: 't') }
  scope :sketch_coaches, -> { coaches.where(is_sketch: 't') }

  #Friendly ID
  friendly_id :name, use: [:slugged, :history]



  #def should_generate_new_friendly_id?
  #  new_record?
  #end
  

  #Mail Actions
  def send_password_reset
    generate_token(:password_reset_token)
    self.update_attributes(password_reset_time: Time.now)
    UserMailer.password_reset(self).deliver
  end

  def send_coach_contact(to, body)
    UserMailer.coach_contact(self, to, body).deliver
  end

  def send_comment_notification(comment_data)
    UserMailer.comment_notification(self, comment_data["from"]["name"], comment_data["message"]).deliver
  end

  #Utility
  def to_s
    self.name
  end

  #invite Funcitons
  def add_invite
    Invite.create do |i|
      i.owner = self
    end
  end

  #Rating Functions
  def total_ratings
    self.liked_by_count + self.disliked_by_count
  end

  def calculate_rating
    total_ratings > 0 ? ((self.liked_by_count.to_f / total_ratings.to_f) * 100) : -1
  end

  def update_rating
    self.rating = calculate_rating
    save
  end

  #END Rating Function

  def has_experience?(theatre_id, experience_type_id)
    !experiences.where( theatre_id: theatre_id, experience_type_id: experience_type_id).empty?
  end

  private
  
  def defaults
    self.bio ||= ""
    self.is_coach ||= "f"
    self.is_active ||= "t"
    self.is_improv ||= "t"
    self.is_sketch ||= "f"
    self.is_admin ||= "f"
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
    self.email.downcase!
  end
end