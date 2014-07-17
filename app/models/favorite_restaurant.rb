class FavoriteRestaurant < ActiveRecord::Base
  belongs_to :device
  belongs_to :restaurant
  
end
