class Theatre < ActiveRecord::Base
  attr_accessible :city_id, :name

  has_and_belongs_to_many :cities
  has_many :experiences
  has_many :theatres, through: :experiences
end
