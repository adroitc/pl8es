class Dish < ActiveRecord::Base
  belongs_to :user
  
  has_many :wines
  has_many :dishes
  
  translates :title, :drinks, :sidedish, :ingredients
end
