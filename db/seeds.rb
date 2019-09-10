# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Locations
USA = Country.create( name: "United States")
NYC = City.create( name: "New York")
PDX = City.create( name: "Portland")

#Theatres
UCB = Theatre.create( name: "Upright Citizens Brigade Theatre")
PIT = Theatre.create( name: "The PIT")
Magnet = Theatre.create( name: "Magnet Theater")

#Experience Types
Student = ExperienceType.create( name: "Student")
Performer = ExperienceType.create( name: "Peformer")
HouseTeam = ExperienceType.create( name: "House Team")
Teacher = ExperienceType.create( name: "Teacher")
