class Navigation < ActiveRecord::Base
  belongs_to :menu
  belongs_to :navigation
  
  has_many :sub_navigations, :class_name => "Navigation"
  has_many :dishes
  
  translates :title
  
  default_scope :order => "position, id"
  
  #attr_accessor :crop_w, :crop_h, :crop_x, :crop_y
  attr_accessor :image_should_process
  has_attached_file :image, {
    :styles => {
      #:crop => ["286x286", :png],
      #:cropped => ["311x283#", :png],
      #:cropped_retina => ["622x566#", :png]
      :crop => {
        :geometry => "286x286",
        :format => :png
      },
      :cropped => {
        :geometry => "311x283#",
        :format => :png,
        :processors => [:cropper]
      },
      :cropped_retina => {
        :geometry => "622x566#",
        :format => :png,
        :processors => [:cropper]
      }
    }
  }
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  
  #def cropping?
  #  !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  #end
  
end
