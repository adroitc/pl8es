class Dish < ActiveRecord::Base
  belongs_to :user
  belongs_to :menu
  belongs_to :navigation
  
  has_many :wines
  belongs_to :dishsuggestion_1, :class_name => "Dish"
  belongs_to :dishsuggestion_2, :class_name => "Dish"
  has_and_belongs_to_many :ingredients
  
  translates :title, :description, :drinks, :sides
  
  default_scope :order => "position, id"
  
  has_attached_file :image, {
    :styles => {
      :original_cropping => {
        :geometry => "286x286",
        :format => :png
      },
      :cropped_default => {
        :geometry => "840x560#",
        :format => :png,
        :processors => [:cropper]
      },
      :cropped_default_retina => {
        :geometry => "1680x1120#",
        :format => :png,
        :processors => [:cropper]
      },
      :cropped_grid => {
        :geometry => "414x276#",
        :format => :png,
        :processors => [:cropper]
      },
      :cropped_grid_retina => {
        :geometry => "828x552#",
        :format => :png,
        :processors => [:cropper]
      },
      :cropped_suggestion => {
        :geometry => "150x100#",
        :format => :png,
        :processors => [:cropper]
      },
      :cropped_suggestion_retina => {
        :geometry => "300x200#",
        :format => :png,
        :processors => [:cropper]
      }
    }
  }
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  validates :image, :dimensions => {
    :width => 1680,
    :height => 1120
  }
  
  validates :title, :length => {
    :maximum => 28
  }
  
  validates :description, :length => {
    :maximum => 700
  }
  
  validates :price, :length => {
    :maximum => 7
  }
  
  validates :drinks, :length => {
    :maximum => 250
  }
  
  validates :sides, :length => {
    :maximum => 250
  }
  
  def self.img_min_dimensions
    {
      :image => [1680, 1120]
    }
  end
  
  def dish_lang
    all_translated_attributes_hash = {}
    navigation.menu.languages.each do |language|
      I18n.locale = language.locale
      
      all_translated_attributes_hash[language.locale] = translated_attributes
    end
    return all_translated_attributes_hash
  end
  
  def dishsuggestion_1_present
    dishsuggestion_1.present? ? "1" : "0"
  end
  
  def dishsuggestion_2_present
    dishsuggestion_2.present? ? "1" : "0"
  end
  
  def dishingredients_present
    if ingredients.count > 0
      return "1"
    else
      return "0"
    end
  end
  
  def dishingredients
    ingredients_translated_attributes_hash = {}
    navigation.menu.languages.each do |language|
      I18n.locale = language.locale
      
      dishingredients_text = ""
      ingredients.each do |ingredient|
        if ingredient != ingredients.first
          dishingredients_text = "\n"
        end
        dishingredients_text += ingredient.title
      end
      
      ingredients_translated_attributes_hash[language.locale] = {:text => dishingredients_text}
    end
    return ingredients_translated_attributes_hash
  end
  
end
