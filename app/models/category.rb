class Category < ActiveRecord::Base
	
	# –––––––––––––
	#   Relations
	# –––––––––––––
	
	belongs_to :menu
	has_many :dishes
	
	belongs_to :category
	has_many :sub_categories, :class_name => "Category"
	
	# –––––––––––––
	#  Validations
	# –––––––––––––
	
	validates :title, presence: true, length: 4..40
	validates :style, presence: true, inclusion: { in: %w(default grid) }
	
	# ––––––––––––––
	#  Translations
	# ––––––––––––––
	
	translates :title
	globalize_accessors
	
	# –––––––––––––
	#    Scopes
	# –––––––––––––
  
	default_scope -> { order("position, id") }
	
	# –––––––––––––
	#    Images
	# –––––––––––––
	
	has_attached_file :image, {
		:styles => {
			:original_cropping => {
				:geometry => "286x286",
				:format => :png
			},
			#:cropped_default => {
			#	 :geometry => "414x276#",
			#	 :format => :png,
			#	 :processors => [:cropper]
			#},
			:cropped_default_retina => {
				:geometry => "828x552#",
				:format => :png,
				:processors => [:cropper]
			}
		},
		:default_url => "http://app.pl8.cc/assets/:class/:attachment/:style.png?"
	}
	
	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
	validates :image, :dimensions => {
		:width => 828,
		:height => 552
	}
	
	def category_lang
		all_translated_attributes_hash = {}
		
		current_locale = I18n.locale
		menu.restaurant.languages.each do |language|
			I18n.locale = language.locale
			
			all_translated_attributes_hash[language.locale] = translated_attributes
		end
		I18n.locale = current_locale
		
		return all_translated_attributes_hash
	end
	
end
