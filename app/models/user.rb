class User < ActiveRecord::Base
	has_and_belongs_to_many :languages
  belongs_to :default_language, :class_name => "Language"
  has_many :openingHours
  has_and_belongs_to_many :categories
  belongs_to :default_menu, :class_name => "Menu"
  has_many :menus
  has_many :daily_dishes, :class_name => "Dish"
  
  has_one :menuColor
  
  belongs_to :supportedFont
  
  translates :description
  
  validates :email, :uniqueness => true
  
  has_attached_file :appmain_image, {
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
      }
    }
  }
  validates_attachment_content_type :appmain_image, :content_type => /\Aimage\/.*\Z/
  validates :appmain_image, :dimensions => {
    :width => 1680,
    :height => 1120
  }
  
  def self.img_min_dimensions
    {
      :appmain_image => [1680, 1120]
    }
  end
  
	def self.loggedIn(session)
		if session[:user_id] && User.exists?(id: session[:user_id])
			return true
		end
		return false
	end
  
end