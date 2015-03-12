class ProfileController < ApplicationController
	
	def index
		unless @user
			redirect_to login_index_path
		end
	end
	
	def public
		if Restaurant.exists?(params[:restaurant_id])
			@visit_restaurant = Restaurant.find(params[:restaurant_id])
			@todays_daily_dishes = @visit_restaurant.daily_dishes.where(:display_date => Date.today.to_datetime)
			@past_daily_dishes = @visit_restaurant.daily_dishes.where('display_date < ?', Date.today.to_datetime).order('display_date DESC')
		else
			raise ActionController::RoutingError.new("Not Found")
		end
	end
end
