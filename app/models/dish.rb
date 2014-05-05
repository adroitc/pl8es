class Dish < ActiveRecord::Base
  belongs_to :user
  belongs_to :menu
  belongs_to :navigation
  
  has_many :wines
  belongs_to :dishsuggestion_1, :class_name => "Dish"
  belongs_to :dishsuggestion_2, :class_name => "Dish"
  has_and_belongs_to_many :ingredients
  
  translates :title, :description, :drinks, :sidedish
  
  default_scope :order => "position, id"
  
  has_attached_file :image, {
    :styles => {
      :crop => {
        :geometry => "286x286",
        :format => :png
      },
      :cropped => {
        :geometry => "758x506#",
        :format => :png,
        :processors => [:cropper]
      },
      :cropped_retina => {
        :geometry => "1516x1012#",
        :format => :png,
        :processors => [:cropper]
      },
      :cropped_mini => {
        :geometry => "77x51#",
        :format => :png,
        :processors => [:cropper]
      }
    }
  }
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  
  def checkCropValues(crop_values)
    crop_values.each do |crop_value|
      if read_attribute(crop_value[0]) != crop_value[1].to_i
        return true
      end
    end
    return false
  end
  
  def image_url
    if image.present?
      return image.url
    else
      return nil
    end
  end
  
  def price_currency
    if price != nil
      return price.to_s+" EUR"
    else
      return nil
    end
  end
  
  def dish_lang
    all_translated_attributes_hash = {}
    navigation.menu.languages.each do |language|
      I18n.locale = language.locale
      
      all_translated_attributes_hash[language.locale] = translated_attributes
    end
    return all_translated_attributes_hash
  end
  
  def dishingredients
    all_translated_attributes_hash = {}
    navigation.menu.languages.each do |language|
      I18n.locale = language.locale
      
      dishingredients_text = ""
      dishingredients.each do |ingredient|
        if ingredient != dishingredients.first
          dishingredients_text = "\n"
        end
        dishingredients_text += ingredient 
      end
      
      all_translated_attributes_hash[language.locale] = dishingredients_text
    end
    all_translated_attributes_hash
  end
  
  def dishsuggestion_1_present
    dishsuggestion_1.present? ? "1" : "0"
  end
  
  def dishsuggestion_2_present
    dishsuggestion_2.present? ? "1" : "0"
  end
  
  def dishingredients_present
    if ingredients.count == 0
      return "1"
    else
      return "0"
    end
  end
  
  def api_output
    all_translated_attributes_hash = {}
    navigation.menu.languages.each do |language|
      I18n.locale = language.locale
      
      all_translated_attributes_hash[language.locale] = translated_attributes
    end
    
    return {
      :id => id,
      :image_fingerprint => image_fingerprint,
      :image_url => image.url(:cropped_retina),
      :dish_lang => all_translated_attributes_hash
    }
  end
  
end
