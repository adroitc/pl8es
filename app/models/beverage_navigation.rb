class BeverageNavigation < ActiveRecord::Base
  belongs_to :beverage_page
  has_many :beverages
  
  default_scope :order => "position, id"
  
  translates :title
	
	validates :title, :presence => true, :length => { :maximum => 40 }
	
  def beverage_navigation_lang
    all_translated_attributes_hash = {}
    
    current_locale = I18n.locale
    beverage_page.restaurant.menu_languages.each do |language|
      I18n.locale = language.locale
      
      all_translated_attributes_hash[language.locale] = translated_attributes
    end
    I18n.locale = current_locale
    
    return all_translated_attributes_hash
  end
  
end
