# == Schema Information
#
# Table name: theatres
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  city_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Theatre < ActiveRecord::Base
  has_and_belongs_to_many :cities
  has_many :experiences
  has_many :theatres, through: :experiences
end
