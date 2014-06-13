class Category < ActiveRecord::Base
  has_and_belongs_to_many :users
  
  translates :title
  
  def category_lang
    all_translated_attributes_hash = {}
    Language.all.each do |language|
      I18n.locale = language.locale
      
      all_translated_attributes_hash[language.locale] = translated_attributes
    end
    return all_translated_attributes_hash
  end
  
end
