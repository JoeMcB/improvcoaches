class UserTheatres < ActiveRecord::Base
  # attr_accessible :title, :body

  belongs_to :theatre
  belongs_to :user
  has_one :experience_type
end
