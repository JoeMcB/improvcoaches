class UserTheatres < ActiveRecord::Base
  belongs_to :theatre
  belongs_to :user
  has_one :experience_type
end
