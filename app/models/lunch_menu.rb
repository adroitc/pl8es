class LunchMenu < ActiveRecord::Base
	belongs_to :dish
	belongs_to :restaurant
	
	validates_presence_of :restaurant_id, :dish_id, :date
end
