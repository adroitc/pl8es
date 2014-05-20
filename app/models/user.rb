class User < ActiveRecord::Base
	has_and_belongs_to_many :languages
  belongs_to :default_language, :class_name => "Language"
  has_many :openingHours
  has_and_belongs_to_many :categories
  belongs_to :default_menu, :class_name => "Menu"
  has_many :menus
  has_many :daily_dishes, :class_name => "Dish"
  
  belongs_to :menuColorTemplate
  
  has_one :menuColor
  
  belongs_to :supportedFont
  
  translates :description
  
  validates :email, :uniqueness => true
  
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
  
  def self.img_min_dimensions
    {
      :logo_image => [312, 208],
      :restaurant_image => [828, 552]
      :appmain_image => [1680, 1120],
      :splashscreen_image => [2048, 1536]
    }
  end
  
	def self.loggedIn(session)
		if session[:user_id] && User.exists?(id: session[:user_id])
			return true
		end
		return false
	end
  
end