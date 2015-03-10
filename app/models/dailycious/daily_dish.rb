class DailyDish < ActiveRecord::Base
	belongs_to :restaurant
	
	default_scope :order => "position, id"
	
	validates :title, :length => 4..80
	validates :price, :length => { :maximum => 7 }
	
	has_attached_file :image, format: :jpg, default_url: "/assets/:class/:attachment/:style.png",
	
	styles: {
		original_cropping: { geometry: "286x286" },
		cropped_menumalist_retina: { geometry: "276x276#", processors: [:cropper] 	},
		cropped_default_retina: { 	geometry: "640x640#", 	processors: [:cropper] },
		cropped_map_retina: { 	geometry: "104x104#", 	processors: [:cropper] },
		cropped_small_retina: { 	geometry: "320x320#", 	processors: [:cropper] }
	}
	
	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
	validates :image, :dimensions => {
		:width => 640,
		:height => 640
	}
	
end
