class Experience < ActiveRecord::Base
  attr_accessible :experience_type_id, :theatre_id, :user_id

  belongs_to :theatre
  belongs_to :user
  belongs_to :experience_type
end
