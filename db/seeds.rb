# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(username: "admin", password: "admin", name: "CHANGE_PASSWORD", address: "", is_admin: true)

Priority.delete_all
Priority.create(priority: "High")
Priority.create(priority: "Medium")
Priority.create(priority: "Low")

Trade.delete_all
Trade.create(name: "Joinery")
Trade.create(name: "Electrical")
Trade.create(name: "Plumbing")
Trade.create(name: "Interior")
