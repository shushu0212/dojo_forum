# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Category

Category.destroy_all

category_list =[
  { name: "分類1" },
  { name: "分類2" },
  { name: "分類3" },
  { name: "分類4" },
  { name: "分類5" }
]

category_list.each do |category|
  Category.create( name: category[:name] )
end
puts "Category created!"

# Role

Role.destroy_all

role_list =[
  { name: "Admin" },
  { name: "Normal" }
]

role_list.each do |role|
  Role.create( name: role[:name] )
end
puts "Role created!"

# Audience

Audience.destroy_all

audience_list =[
  { name: "All" },
  { name: "Friend" },
  { name: "Myself" }
]

audience_list.each do |audience|
  Audience.create( name: audience[:name] )
end
puts "Audience created!"


# Default admin

User.create(email: "admin@example.com", password: "12345678", role_id: "1")
puts "Default admin created!"
