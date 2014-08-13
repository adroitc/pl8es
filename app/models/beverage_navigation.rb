class BeverageNavigation < ActiveRecord::Base
  belongs_to :beverage_page
  
  translates :title
  
end
