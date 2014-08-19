class BeveragePage < ActiveRecord::Base
  belongs_to :restaurant
  has_many :beverage_navigations
  
  default_scope :order => "position, id"
  
  validates :title, :presence => true, :length => {
    :maximum => 40
  }
  
  has_attached_file :image, {
    :styles => {
      :original_cropping => {
        :geometry => "286x286",
        :format => :png
      },
      #:cropped_default => {
      #  :geometry => "642x252#",
      #  :format => :png,
      #  :processors => [:cropper]
      #},
      :cropped_default_retina => {
        :geometry => "1292x512#",
        :format => :png,
        :processors => [:cropper]
      }
    }
  }
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  validates :image, :dimensions => {
    :width => 1284,
    :height => 504
  }
  
end
