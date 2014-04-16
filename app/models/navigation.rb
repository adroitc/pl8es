class Navigation < ActiveRecord::Base
  belongs_to :menu
  belongs_to :navigation
  
  has_many :sub_navigations, :class_name => "Navigation"
  has_many :dishes
  
  translates :title
  
  default_scope :order => "position, id"
end
