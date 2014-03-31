class Navigation < ActiveRecord::Base
  has_many :sub_navigations, :class_name => "Navigation"
  has_many :dishes
  
  translates :title
end
