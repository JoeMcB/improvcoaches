# == Schema Information
#
# Table name: experience_types
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ExperienceType < ActiveRecord::Base
  has_many :experiences
  has_many :users, through: :experiences
  has_many :theatres, through: :experiences
end
