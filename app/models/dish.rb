class Dish < ActiveRecord::Base
  belongs_to :user
  belongs_to :menu
  belongs_to :navigation
  
  has_many :wines
  has_many :dishes
  
  translates :title, :drinks, :sidedish, :ingredients
  
  default_scope :order => "position, id"
  
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
        :geometry => "758x506#",
        :format => :png,
        :processors => [:cropper]
      },
      :cropped_retina => {
        :geometry => "1516x1012#",
        :format => :png,
        :processors => [:cropper]
      }
    }
  }
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end
