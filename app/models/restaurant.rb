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
        "updated_at >= (?) AND active = (?)",
        DateTime.now-31.days,
        true
      ])
    end
  end
  has_many :menus
  has_many :dishes
  has_many :beveragePages
  has_many :favoriteRestaurants
  has_many :devices, :through => :favoriteRestaurants
  has_one :dailycious_plan
  has_many :dailycious_credits
  
  translates :description
  
  validates :name, :presence => true, :length => {
    :minimum => 4,
    :maximum => 75
  }
  validates :description, :allow_blank => true, :length => {
    :maximum => 400
  }
  validates :website, :allow_blank => true, :presence => true, :length => {
    :minimum => 6,
    :maximum => 255
  }
  validates :telephone, :allow_blank => true, :presence => true, :length => {
    :minimum => 6,
    :maximum => 255
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
    menu_languages.sort_by{|l| l.id}
  end
  
  def menu_default_languages_include(id)
    (Menu.all.map{|m| m.default_language}.uniq{|l| x.id}.find_all{|l| l.id = id}.count > 0) || (Menu.all.map{|m| m.default_language}.uniq{|l| x.id}.find_all{|l| l.id = id}.count == 0 && menu_languages.count == 1 && menu_languages.find_all{|l| l.id = id}.count == 1)
  end
  
end
