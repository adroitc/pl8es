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
      }
    }
  }
  validates_attachment_content_type :appmain_image, :content_type => /\Aimage\/.*\Z/
  def appmain_image_url
    return appmain_image.url
  end
  
	def self.loggedIn(session)
		if session[:user_id] && User.exists?(id: session[:user_id])
			return true
		end
		return false
	end
  
end