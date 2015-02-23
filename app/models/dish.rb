class Dish < ActiveRecord::Base
	
	# –––––––––––––
	#   Relations
	# –––––––––––––
	
	belongs_to :restaurant
	belongs_to :menu
	belongs_to :category
	has_many :wines
	
	belongs_to :dishsuggestion_1, :class_name => "Dish"
	belongs_to :dishsuggestion_2, :class_name => "Dish"
	
	has_and_belongs_to_many :ingredients
	
	# –––––––––––––
	#  Validations
	# –––––––––––––
	
	validates :title, :presence => true, :length => 4..40
	validates :description, :length => { :maximum => 400 }
	validates :price, :length => { :maximum => 7 }
	validates :drinks, :length => { :maximum => 255 }
	validates :sides, :length => { :maximum => 255 }
	
	# ––––––––––––––
	#  Translations
	# ––––––––––––––
	
	translates :title, :description, :drinks, :sides
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
			#	 :geometry => "840x560#",
			#	 :format => :png,
			#	 :processors => [:cropper]
			#},
			:cropped_default_retina => {
				:geometry => "1680x1120#",
				:format => :png,
				:processors => [:cropper]
			},
			#:cropped_grid => {
			#	 :geometry => "414x276#",
			#	 :format => :png,
			#	 :processors => [:cropper]
			#},
			:cropped_grid_retina => {
				:geometry => "828x552#",
				:format => :png,
				:processors => [:cropper]
			},
			#:cropped_suggestion => {
			#	 :geometry => "150x100#",
			#	 :format => :png,
			#	 :processors => [:cropper]
			#},
			:cropped_suggestion_retina => {
				:geometry => "300x200#",
				:format => :png,
				:processors => [:cropper]
			}
		},
		:default_url => "http://app.pl8.cc/assets/:class/:attachment/:style.png?"
	}
	
	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
	validates :image, :dimensions => {
		:width => 1680,
		:height => 1120
	}
	
	def dishingredients
		ingredients_translated_attributes_hash = {}
		category.menu.restaurant.languages.each do |language|
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
