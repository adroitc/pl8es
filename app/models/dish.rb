class Dish < ActiveRecord::Base
  belongs_to :user
  belongs_to :menu
  belongs_to :navigation
  
  has_many :wines
  has_many :dishes
  
  translates :title, :drinks, :sidedish, :ingredients
  
  default_scope :order => "position, id"
end
