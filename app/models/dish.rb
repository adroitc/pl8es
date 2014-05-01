class Dish < ActiveRecord::Base
  belongs_to :user
  belongs_to :menu
  belongs_to :navigation
  
  has_many :wines
  belongs_to :dishsuggestion_1, :class_name => "Dish"
  belongs_to :dishsuggestion_2, :class_name => "Dish"
  
  translates :title, :description, :drinks, :sidedish, :ingredients
  
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
  
  def image_url
    if image.present?
      return image.url
    else
      return nil
    end
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
  
end
