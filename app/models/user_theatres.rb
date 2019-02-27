# == Schema Information
#
# Table name: user_theatres
#
#  user_id            :integer
#  theatre_id         :integer
#  experience_type_id :integer
#

class UserTheatres < ActiveRecord::Base
  belongs_to :theatre
  belongs_to :user
  has_one :experience_type
end
