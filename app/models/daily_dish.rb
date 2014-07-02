class DailyDish < ActiveRecord::Base
  belongs_to :user
  
  default_scope :order => "position, id"
  
  has_attached_file :image, {
    :styles => {
      :original_cropping => {
        :geometry => "286x286",
        :format => :png
      },
      :cropped_menumalist_retina => {
        :geometry => "276x276#",
        :format => :png,
        :processors => [:cropper]
      },
      :cropped_default_retina => {
        :geometry => "640x640#",
        :format => :png,
        :processors => [:cropper]
      },
      :cropped_map_retina => {
        :geometry => "104x104#",
        :format => :png,
        :processors => [:cropper]
      },
      :cropped_small_retina => {
        :geometry => "320x320#",
        :format => :png,
        :processors => [:cropper]
      }
    }
  }
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  validates :image, :dimensions => {
    :width => 640,
    :height => 640
  }
  
  validates :title, :length => {
    :maximum => 60
  }
  
  validates :price, :length => {
    :maximum => 7
  }
  
end
