class Navigation < ActiveRecord::Base
  belongs_to :menu
  belongs_to :navigation
  
  has_many :sub_navigations, :class_name => "Navigation"
  has_many :dishes
  
  translates :title
  
  default_scope :order => "position, id"
  
  has_attached_file :image, {
    :styles => {
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
  def image_url
    if image.present?
      return image.url
    else
      return nil
    end
  end

  def navigation_lang
    all_translated_attributes_hash = {}
    menu.languages.each do |language|
      I18n.locale = language.locale
      
      all_translated_attributes_hash[language.locale] = translated_attributes
    end
    return all_translated_attributes_hash
  end
  
  #def cropping?
  #  !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  #end
  
end
