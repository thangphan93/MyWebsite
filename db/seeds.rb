# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Item.create(program: 'Strength', price: 10)
Item.create(program: 'Condition', price: 5)
Item.create(program: 'Weightloss', price: 20)

a = User.find(1)
a.admin = true
a.save