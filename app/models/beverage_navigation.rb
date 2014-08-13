class BeverageNavigation < ActiveRecord::Base
  belongs_to :beveragePage
  has_many :beverages
  
  translates :title
  
  validates :title, :allow_blank => true, :length => {
    :maximum => 40
  }
  
end
