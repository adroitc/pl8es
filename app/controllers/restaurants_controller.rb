class RestaurantsController < ApplicationController
	
	before_action :get_restaurant, only: [:show]
	before_action :authenticate_user, except: [:show, :index]

  def index
    render layout: "dailycious"
    @restaurants = Restaurant.all
  end
	
	def new
		@restaurant = Restaurant.new
	end
	
	def create
		@restaurant = Restaurant.new(restaurant_params)
		if @restaurant.save
			redirect_to restaurant_path(@restaurant)
		else
			render :new
		end
	end
	
	def show
		@todays_daily_dishes = @restaurant.daily_dishes.where(:display_date => Date.today.to_datetime)
		@past_daily_dishes = @restaurant.daily_dishes.where('display_date < ?', Date.today.to_datetime).order('display_date DESC')
	end
	
	private
		
		def get_restaurant
			@restaurant = Restaurant.find_by_id(params[:id]) || not_found
		end
		
		def restaurant_params
			params.require(:restaurant).permit(:name)
		end
end
