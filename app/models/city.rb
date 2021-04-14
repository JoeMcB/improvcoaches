# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  country_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  subdomain  :string(255)
#  has_spaces :boolean
#

class City < ActiveRecord::Base
  has_many :users
  has_many :spaces
  has_and_belongs_to_many :theatres
  
  belongs_to :country

  def coaches
    users.coaches
  end

  def other_theatres
    Theatre.where('id NOT IN (?)', theatres.map(&:id))
  end
end
