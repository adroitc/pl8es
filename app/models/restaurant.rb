class Restaurant < ActiveRecord::Base
  belongs_to :user
  has_one :location
  belongs_to :default_language, :class_name => "Language"
  has_and_belongs_to_many :languages
  has_and_belongs_to_many :categories
  has_many :daily_dishes
  has_one :menuColor
  belongs_to :menuColorTemplate
  belongs_to :supportedFont
  belongs_to :defaultMenu, :class_name => "Menu"
  has_many :menus
  has_many :dishes
  
  translates :description
  
  def menu_languages
    menu_languages = []
    menus.each do |menu|
      menu.languages.each do |menu_language|
        if menu_languages.select{|language| language[:locale] == menu_language.locale}.count == 0
          menu_languages.push(menu_language)
        end
      end
    end
    if !menu_languages.include?(default_language) && default_language != nil
      menu_languages.push(default_language)
    end
    menu_languages
  end
  
end
