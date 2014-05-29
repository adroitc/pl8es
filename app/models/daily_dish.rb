class DailyDish < ActiveRecord::Base
  belongs_to :user
  
  has_attached_file :image, {
    :styles => {
      :original_cropping => {
        :geometry => "286x286",
        :format => :png
      },
      :cropped_default_retina => {
        :geometry => "640x640#",
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
  
end
