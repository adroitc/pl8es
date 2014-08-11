class MenuColor < ActiveRecord::Base
  belongs_to :restaurant
  
  validates :background, :presence => true, :length => {
    :minimum => 4,
    :maximum => 7
  }
  validates :bar_background, :presence => true, :length => {
    :minimum => 4,
    :maximum => 7
  }
  validates :nav_text, :presence => true, :length => {
    :minimum => 4,
    :maximum => 7
  }
  validates :nav_text_active, :presence => true, :length => {
    :minimum => 4,
    :maximum => 7
  }
  
end
