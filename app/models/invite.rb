class Invite < ActiveRecord::Base
  validates :owner, presence: true
  validates :code, presence: true, uniqueness: true
  validates :status, inclusion: { in: ['free', 'pending', 'used'] }


  has_one :user
  belongs_to :owner, class_name: :User

  after_initialize :defaults

  scope :free, -> { where(status: 'free') }
  scope :pending, -> { where(status: 'pending') }
  scope :used, -> { where(status: 'used') }
  scope :sent, -> { where("status = ? OR status = ?", "pending", "used") }

  def to_param
    code
  end

  def defaults
  	self.status ||= 'free'
    self.code ||= SecureRandom.hex(8)
  end

  def deliver
    InviteMailer.send_invitation(self).deliver
  end

end
