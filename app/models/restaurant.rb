class Restaurant < ActiveRecord::Base
	
	# –––––––––––––
	#   Relations
	# –––––––––––––
	
	belongs_to :user
	
	has_one :location
	
	belongs_to :default_language, :class_name => "Language"
	has_and_belongs_to_many :languages
	has_and_belongs_to_many :tags
	
	has_one :menuColor
	belongs_to :menuColorTemplate
	belongs_to :supportedFont
	
	# –– devices & clients
	
	has_many :favoriteRestaurants
	has_many :devices, :through => :favoriteRestaurants
	has_many :clients do
		def actives()
			where([
				"updated_at >= (?) AND active = (?)",
				DateTime.now-31.days,
				true
			])
		end
	end
	
	belongs_to :default_menu, :class_name => "Menu"
	
	# – menumalist
	has_many :menus
	
	has_many :dishes
	has_many :daily_dishes
	
	translates :description
	
	# –––––––––––––
	#  Validations
	# –––––––––––––
	
	validates :name, :presence => true, :length => 2..75
	validates :description, :allow_blank => true, :length => { :maximum => 400 }
	validates :website, :allow_blank => true, :presence => true, :length => 6..255
	validates :telephone, :allow_blank => true, :presence => true, :length => 6..255
	
	# –––––––––––––
	#    Images
	# –––––––––––––
	
	# –– logo_image
	has_attached_file :logo_image, format: :jpg, default_url: "/assets/:class/:attachment/:style.png",
	styles: {
		original_cropping: { geometry: "286x286" },
		cropped_website: { geometry: "108x72#", 	processors: [:cropper] },
		cropped_default_retina: { 	geometry: "312x208#", 	processors: [:cropper] },
		cropped_dailycious_retina: { geometry: "174x116#", processors: [:cropper] }
	}
	
	validates_attachment_content_type :logo_image, content_type: /\Aimage\/.*\Z/
	validates :logo_image, dimensions: { width: 312, height: 208 }
	
	# –– restaurant_image
	has_attached_file :restaurant_image, format: :jpg, default_url: "/assets/:class/:attachment/:style.png",
	styles: { 
		original_cropping: { geometry: "286x286" },
		cropped_default_retina: { geometry: "828x552#", processors: [:cropper] }
	}
	
	validates_attachment_content_type :restaurant_image, content_type: /\Aimage\/.*\Z/
	validates :restaurant_image, dimensions: { width: 828, height: 552 }
	
	# –– appmain_image
	has_attached_file :appmain_image, format: :jpg, default_url: "/assets/:class/:attachment/:style.png",
	styles: {
		original_cropping: { geometry: "286x286" },
		cropped_default_retina: { geometry: "1680x1120#", processors: [:cropper] }
	}
	
	validates_attachment_content_type :appmain_image, content_type: /\Aimage\/.*\Z/
	validates :appmain_image, dimensions: { width: 1680, height: 1120 }
	
	# –– splashscreen_image
	has_attached_file :splashscreen_image, format: :jpg, default_url: "/assets/:class/:attachment/:style.png",
	styles: {
		original_cropping: { geometry: "286x286" },
		cropped_default_retina: { geometry: "2048x1536#", processors: [:cropper] }
	}
	
	validates_attachment_content_type :splashscreen_image, content_type: /\Aimage\/.*\Z/
	validates :splashscreen_image, dimensions: { width: 2048, height: 1536 }
	
end
