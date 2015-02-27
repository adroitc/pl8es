class Dish < ActiveRecord::Base
	
	# –––––––––––––
	#   Relations
	# –––––––––––––
	
	belongs_to :restaurant
	
	has_many :dish_ingredients
	has_many :ingredients, :through => :dish_ingredients
	
	# –––––––––––––
	#  Validations
	# –––––––––––––
	
	validates :price, :length => { :maximum => 7 }
	
	# ––––––––––––––
	#  Translations
	# ––––––––––––––
	
	translates :title, :description
	globalize_accessors
	
	# –––––––––––––
	#    Scopes
	# –––––––––––––
	
	default_scope -> { order("dishes.position, dishes.id") }
	
	# –––––––––––––
	#    Images
	# –––––––––––––
	
	attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
	has_attached_file :image, format: :jpg, default_url: "/assets/:class/images/:style.png",
	
	styles: {
		web_preview_cropped: { geometry: "351x234#", processors: [:nu_cropper] },
		web_large: { geometry: "747x497" },
		web_large_cropped: { geometry: "747x497#", processors: [:nu_cropper] },
		original_cropping: { geometry: "286x286" },
		cropped_default_retina: { geometry: "1680x1120#", processors: [:nu_cropper]},
		cropped_grid_retina: { geometry: "828x552#", processors: [:nu_cropper]},
		cropped_suggestion_retina: { geometry: "300x200#", processors: [:nu_cropper]}
	}
	
	after_update :reprocess_image, :if => :cropping?
	
	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
	validates :image, :dimensions => { width: 1680, height: 1120 }
	
	def image_geometry(style = :original)
		@geometry ||= {}
		@geometry[style] ||= Paperclip::Geometry.from_file(image.path(style))
	end
	
	def cropping?
		crop_x.present? && crop_y.present? && crop_w.present? && crop_h.present?
	end
	
	private
	
		def reprocess_image
			image.assign(image)
			image.save
		end
end

Dish::Translation.class_eval do
	validates :title, presence: true, length: 4..40
	validates :description, presence: true, length: { maximum: 400 }
end