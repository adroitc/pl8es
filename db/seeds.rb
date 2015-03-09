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

SupportedFont.create([
  {
    :title => "GillSans",
    :name_navigation => "GillSans",
    :size_navigation => "18",
    :name_heading => "GillSans",
    :size_heading => "30",
    :name_heading_small => "GillSans",
    :size_heading_small => "24",
    :name_description => "GillSans-Light",
    :size_description => "18",
    :name_price => "GillSans",
    :size_price => "18",
    :name_card_tab_title => "GillSans",
    :size_card_tab_title => "18"
  }
])

User.create([
  {
    :isAdmin => true,
    :email => "marc@roemer.io",
    :password => "Lol123lol",
    :password_confirmation => "Lol123lol",
    :restaurant => Restaurant.create(
      :name => "Demo restaurant",
      :location => Location.create(
        :latitude => 48.2087105,
        :longitude => 16.372654,
        :address => "Stephansplatz 1",
        :zip => "1010",
        :city => "Vienna",
        :country => "Austria"
      ),
      :background_type => "color",
      :menuColor => MenuColor.create(
        :background => "#000000",
        :bar_background => "#000000",
        :nav_text => "#ffffff",
        :nav_text_active => "#999999"
      ),
      :download_code => "DEMO-2",
      :supportedFont => SupportedFont.first,
      :default_language => Language.first
    )
  }
])

r = Restaurant.first
r.languages << Language.first
r.languages << Language.last
r.save

User.create([
  {
    :isAdmin => true,
    :email => "s.mairhofer@pl8.cc",
    :password => "Lol123lol",
    :password_confirmation => "Lol123lol",
    :restaurant => Restaurant.create(
      :name => "Demo restaurant",
      :location => Location.create(
        :latitude => 48.202452,
        :longitude => 16.393683,
        :address => "Erdbergstraße 10",
        :zip => "1030",
        :city => "Vienna",
        :country => "Austria"
      ),
      :background_type => "color",
      :menuColor => MenuColor.create(
        :background => "#000000",
        :bar_background => "#000000",
        :nav_text => "#ffffff",
        :nav_text_active => "#999999"
      ),
      :download_code => "DEMO",
      :supportedFont => SupportedFont.first,
      :default_language => Language.first
    )
  }
])