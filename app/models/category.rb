class Category < ActiveRecord::Base
  has_and_belongs_to_many :restaurants
  
  translates :title
  
  def category_lang
    
    current_locale = I18n.locale
    all_translated_attributes_hash = {}
    Language.all.each do |language|
      I18n.locale = language.locale
      
      all_translated_attributes_hash[language.locale] = translated_attributes
    end
    I18n.locale = current_locale
    
    return all_translated_attributes_hash
  end
  
end
