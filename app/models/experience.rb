# == Schema Information
#
# Table name: experiences
#
#  id                 :integer          not null, primary key
#  theatre_id         :integer
#  user_id            :integer
#  experience_type_id :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Experience < ActiveRecord::Base
  belongs_to :theatre
  belongs_to :user
  belongs_to :experience_type
end
