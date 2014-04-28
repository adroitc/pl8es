# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Language.create([{title: "english", locale: "en"}, {title: "deutsch", locale: "de"}, {title: "français", locale: "fr"}, {title: "español", locale: "es"}, {title: "italiano", locale: "it"}, {title: "русский", locale: "ru"}, {title: "português", locale: "pt"}])

MenuLabel.create([{title: "Lunch"}, {title: "Dinner"}])

user = User.create({:email => "marc@illnox.com", :password => "lol123lol", :name => "Marc's restaurant", :menuColor => MenuColor.create(), :download_code => SecureRandom.hex(3).upcase})