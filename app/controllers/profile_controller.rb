class ProfileController < ApplicationController
	
	def restaurant
    if Restaurant.exists?(params[:restaurant_id])
      @restaurant = Restaurant.find(params[:restaurant_id])
      @todays_daily_dishes = @restaurant.daily_dishes.where(:display_date => Date.today.to_datetime)
      @past_daily_dishes = @restaurant.daily_dishes.where('display_date < ?', Date.today.to_datetime).order('display_date DESC')
    else
      raise ActionController::RoutingError.new("Not Found")
    end
	end

end
