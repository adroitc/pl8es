class BeverageNavigation < ActiveRecord::Base
  belongs_to :beverage_page
  has_many :beverages
  
  translates :title
  
  validates :title, :allow_blank => true, :length => {
    :maximum => 40
  }
  
end