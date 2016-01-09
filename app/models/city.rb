class City < ActiveRecord::Base
  attr_accessible :country_id, :name, :subdomain

  has_many :users
  has_many :spaces
  has_and_belongs_to_many :theatres

  def coaches
  	users.coaches
  end

  def other_theatres
  	Theatre.where("id NOT IN (?)", theatres.map{ |t| t.id })
  end
end
