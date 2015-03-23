class RestaurantsController < ApplicationController
	
	before_filter :get_restaurant, only: [:show]
	
	def show
		@todays_daily_dishes = @restaurant.daily_dishes.where(:display_date => Date.today.to_datetime)
		@past_daily_dishes = @restaurant.daily_dishes.where('display_date < ?', Date.today.to_datetime).order('display_date DESC')
	end
	
	private
		
		def get_restaurant
			@restaurant = Restaurant.find_by_id(params[:id]) || not_found
		end
end
