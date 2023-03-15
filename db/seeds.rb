# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Locations
united_states = Country.create!( name: "United States")
new_york = City.create!( name: "New York", country: united_states)
los_angeles = City.create!( name: "Los Angeles", country: united_states)

#Theatres
ucb = Theatre.create!( name: "Upright Citizens Brigade Theatre", cities: [ new_york, los_angeles])
pit = Theatre.create!( name: "The PIT", cities: [ new_york ])
magnet = Theatre.create!( name: "Magnet Theater", cities: [ new_york ])

#Experience Types
student = ExperienceType.create!( name: "Student")
performer = ExperienceType.create!( name: "Performer")
house_team = ExperienceType.create!( name: "House Team")
teacher = ExperienceType.create!( name: "Teacher")

#Admin User
admin = User.create!(
  name: 'Improv Admin',
  email: 'admin@improvcoaches.com',
  password: 'adminpass',
  is_admin: true
)

# Coaches
5.times do |i|
  User.create!(name: "Coach #{i}", email: "coache_#{i}@improvcoaches.com", password: 'pass', is_coach: true, is_improv: true, is_sketch: true, city: new_york)
end
