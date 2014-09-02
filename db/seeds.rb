Language.create([
  {
    title: "english",
    locale: "en"
  },
  {
    title: "deutsch",
    locale: "de"
  },
  {
    title: "français",
    locale: "fr"
  },
  {
    title: "español",
    locale: "es"
  },
  {
    title: "italiano",
    locale: "it"
  },
  {
    title: "русский",
    locale: "ru"
  },
  {
    title: "português",
    locale: "pt"
  }
])

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
      :default_language => Language.first,
      :dailycious_plan => DailyciousPlan.create()
    )
  }
])