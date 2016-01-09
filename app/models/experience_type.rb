class ExperienceType < ActiveRecord::Base
  attr_accessible :name

  has_many :user_theatres
end
