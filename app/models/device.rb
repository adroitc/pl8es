class Device < ActiveRecord::Base
  belongs_to :user
  has_many :favoriteRestaurants
  has_many :restaurants, :through => :favoriteRestaurants
  
end
