# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(
  name: 'admin',
  password: 'admin',
  password_confirmation: 'admin',
  email: 'admin@improvcoaches.com',
  is_admin: true
)

#Locations
usa = Country.create( name: "United States")
nyc = City.create( name: "New York", country: usa)
la = City.create( name: "Los Angeles", country: usa)

#Theatres
Theatre.create( name: "Upright Citizens Brigade Theatre", cities: [nyc, la])
Theatre.create( name: "The PIT", cities: [nyc])
Theatre.create( name: "Magnet Theater", cities: [nyc])

#Experience Types
ExperienceType.create( name: "Student")
ExperienceType.create( name: "Peformer")
ExperienceType.create( name: "House Team")
ExperienceType.create( name: "Teacher")
