# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
restaurent_names = [
  {name: "Domino's Pizza"}, {name: "Empire Restaurant"}, {name: "Thlassery Restaurent"}, {name: "Burger King"},
  {name: "McDonald's"}, {name: "KFC"}, {name: "EatFit"}, {name: "Kottaram"}
]
Restaurant.create(restaurent_names)