class MenuColorTemplate < ActiveRecord::Base
  has_attached_file :preview_image, {
    :styles => {
      :original_cropping => {
        :geometry => "286x286",
        :format => :png
      },
      :cropped_default_retina => {
        :geometry => "288x216#",
        :format => :png,
        :processors => [:cropper]
      }
    }
  }
  validates_attachment_content_type :preview_image, :content_type => /\Aimage\/.*\Z/
  validates :preview_image, :dimensions => {
    :width => 288,
    :height => 216
  }
  
  def self.img_min_dimensions
    {
      :preview_image => [288, 216]
    }
  end
end
