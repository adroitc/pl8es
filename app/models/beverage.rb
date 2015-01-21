class Beverage < ActiveRecord::Base
  belongs_to :beverage_navigation
  
  default_scope :order => "position, id"
  
  translates :title

  
  def beverage_lang
    all_translated_attributes_hash = {}
    
    current_locale = I18n.locale
    beverage_navigation.beverage_page.restaurant.languages.each do |language|
      I18n.locale = language.locale
      
      all_translated_attributes_hash[language.locale] = translated_attributes
    end
    I18n.locale = current_locale
    
    return all_translated_attributes_hash
  end
  
end
