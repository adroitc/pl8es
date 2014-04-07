class Navigation < ActiveRecord::Base
  belongs_to :menu
  
  has_many :sub_navigations, :class_name => "Navigation"
  has_many :dishes
  
  translates :title
end
