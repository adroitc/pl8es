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

MenuLabel.create([
  {
    title: "Lunch"
  },
  {
    title: "Dinner"
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
    :email => "marc@roemer.io",
    :password => "lol123lol",
    :name => "Marc's restaurant",
    :location => Location.create(),
    :background_type => "color",
    :menuColor => MenuColor.create(),
    :download_code => "8D34C8",
    :supportedFont => SupportedFont.first,
    :default_language => Language.first
  }
])