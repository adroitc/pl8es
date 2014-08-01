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
  has_many :clients do
    def actives()
      where([
        "updated_at >= (?)",
        DateTime.now-31.days
      ])
    end
  end
  has_many :menus
  has_many :dishes
  has_many :favoriteRestaurants
  has_many :devices, :through => :favoriteRestaurants
  
  translates :description
  
  validates :name, :length => {
    :maximum => 28
  }
  
  has_attached_file :logo_image, {
    :styles => {
      :original_cropping => {
        :geometry => "286x286",
        :format => :png
      },
      :cropped_website => {
        :geometry => "108x72#",
        :format => :png,
        :processors => [:cropper]
      },
      :cropped_default_retina => {
        :geometry => "312x208#",
        :format => :png,
        :processors => [:cropper]
      },
      :cropped_dailycious_retina => {
        :geometry => "174x116#",
        :format => :png,
        :processors => [:cropper]
      }
    }
  }
  validates_attachment_content_type :logo_image, :content_type => /\Aimage\/.*\Z/
  validates :logo_image, :dimensions => {
    :width => 312,
    :height => 208
  }
  
  has_attached_file :restaurant_image, {
    :styles => {
      :original_cropping => {
        :geometry => "286x286",
        :format => :png
      },
      :cropped_default_retina => {
        :geometry => "828x552#",
        :format => :png,
        :processors => [:cropper]
      }
    }
  }
  validates_attachment_content_type :restaurant_image, :content_type => /\Aimage\/.*\Z/
  validates :restaurant_image, :dimensions => {
    :width => 828,
    :height => 552
  }
  
  has_attached_file :appmain_image, {
    :styles => {
      :original_cropping => {
        :geometry => "286x286",
        :format => :png
      },
      :cropped_default_retina => {
        :geometry => "1680x1120#",
        :format => :png,
        :processors => [:cropper]
      }
    }
  }
  validates_attachment_content_type :appmain_image, :content_type => /\Aimage\/.*\Z/
  validates :appmain_image, :dimensions => {
    :width => 1680,
    :height => 1120
  }
  
  has_attached_file :splashscreen_image, {
    :styles => {
      :original_cropping => {
        :geometry => "286x286",
        :format => :png
      },
      :cropped_default_retina => {
        :geometry => "2048x1536#",
        :format => :png,
        :processors => [:cropper]
      }
    }
  }
  validates_attachment_content_type :splashscreen_image, :content_type => /\Aimage\/.*\Z/
  validates :splashscreen_image, :dimensions => {
    :width => 2048,
    :height => 1536
  }
  
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
