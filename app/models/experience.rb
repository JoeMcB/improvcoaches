class Experience < ActiveRecord::Base
  belongs_to :theatre
  belongs_to :user
  belongs_to :experience_type
end
