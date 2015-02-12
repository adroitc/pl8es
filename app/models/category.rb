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
	
	attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
	has_attached_file :image, format: :png, default_url: "/assets/:class/images/:style.png",
	
	styles: {
		web_preview_cropped: { geometry: "256x171#", processors: [:nu_cropper] },
		web_large: { geometry: "580x388" },
		web_large_cropped: { geometry: "580x388#", processors: [:nu_cropper] },
		original_cropping: { geometry: "286x286" },
		cropped_default_retina: { geometry: "828x552#", processors: [:nu_cropper]}
	}
	
	after_update :reprocess_image, :if => :cropping?
	
	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
	validates :image, :dimensions => { width: 828, height: 552 }
	
	def image_geometry(style = :original)
		@geometry ||= {}
		@geometry[style] ||= Paperclip::Geometry.from_file(image.path(style))
	end
	
	def cropping?
		crop_x.present? && crop_y.present? && crop_w.present? && crop_h.present?
	end
	
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
	
	private
	
		def reprocess_image
			image.assign(image)
			image.save
		end
	
end

Category::Translation.class_eval do
	validates :title, presence: true, length: 4..40
end