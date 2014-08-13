class Beverage < ActiveRecord::Base
  belongs_to :beverage_navigation
  
  translates :title
  
end
