Language.create([
  {
    title: "english",
    locale: "en"
  },
  {
    title: "deutsch",
    locale: "de"
  }
])

# ––––––––––––––––
#   Ingredients
# ––––––––––––––––

# only import the ingredients if they're not yet present
unless Ingredient.count == 14
	ingredients = [
									{ abbreviation: "A", translations: { en: "Cereals containing gluten",		de: "Glutenhaltiges Getreide" } },
									{ abbreviation: "B", translations: { en: "Curstaceans",									de: "Krebstiere" } },
									{ abbreviation: "C", translations: { en: "Eggs",												de: "Eier" } },
									{ abbreviation: "D", translations: { en: "Fish",												de: "Fisch" } },
									{ abbreviation: "E", translations: { en: "Peanuts",											de: "Erdnüsse" } },
									{ abbreviation: "F", translations: { en: "Soy(-beans)",									de: "Soja(-bohnen)" } },
									{ abbreviation: "G", translations: { en: "Milk - Lactose",							de: "Milch - Laktose" } },
									{ abbreviation: "H", translations: { en: "Nuts",												de: "Schalenfrüchte (Nüsse)" } },
									{ abbreviation: "L", translations: { en: "Celery",											de: "Sellerie" } },
									{ abbreviation: "M", translations: { en: "Mustard",											de: "Senf" } },
									{ abbreviation: "N", translations: { en: "Sesame seeds",								de: "Sesamsamen" } },
									{ abbreviation: "O", translations: { en: "Sulfur dioxide and sulfites", de: "Schwefeldioxid und Sulfite" } },
									{ abbreviation: "P", translations: { en: "Lupins",											de: "Lupinen" } },
									{ abbreviation: "R", translations: { en: "Molluscs",										de: "Weichtiere" } }
								]
	
	ingredients.each do |ingredient|
		new_ingredient = Ingredient.new(abbreviation: ingredient[:abbreviation])
		
		ingredient[:translations].each do |locale, translation|
			I18n.locale = locale
			new_ingredient.title = translation
		end
		
		new_ingredient.save
	end
end

u = User.new(:type => "Admin", :email => "dave.gson@gmail.com	", :password => "okokokok", :password_confirmation => "okokokok")
u.skip_confirmation!
u.restaurant = Restaurant.create(
									:name => "Demo restaurant",
									:location => Location.create(
										:latitude => 48.2087105,
										:longitude => 16.372654,
										:address => "Stephansplatz 1",
										:zip => "1010",
										:city => "Vienna",
										:country => "Austria"
									),
									:download_code => "DEMO 2",
									:background_type => "color",
									:default_language => Language.first
								)
u.save


r = Restaurant.first
r.languages << Language.first
r.languages << Language.last
r.save

u = User.new(:type => "Admin", :email => "s.mairhofer@pl8.cc", :password => "okokokok", :password_confirmation => "okokokok")
u.skip_confirmation!
u.restaurant = Restaurant.create(
									:name => "Demo restaurant",
									:location => Location.create(
										:latitude => 48.202452,
										:longitude => 16.393683,
										:address => "Erdbergstraße 10",
										:zip => "1030",
										:city => "Vienna",
										:country => "Austria"
									),
									:download_code => "DEMO",
									:background_type => "color",
									:default_language => Language.first
								)
u.save