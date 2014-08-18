class Beverage < ActiveRecord::Base
  belongs_to :beverage_navigation
  
  default_scope :order => "position, id"
  
  translates :title
  
end
