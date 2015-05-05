class RestaurantsController < ApplicationController
	
	before_action :get_restaurant, only: [:show]
	before_action :authenticate_user, except: [:show, :index]

  def index
    render layout: "dailycious"
    @restaurants = Restaurant.all
  end
	
	def new
		# for now, only allow one restaurant per user
		redirect_to dashboard_index_path if current_user.restaurant.present?
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
	end
	
	private
		
		def get_restaurant
			@restaurant = Restaurant.find_by_id(params[:id]) || not_found
		end
		
		def restaurant_params
			params.require(:restaurant).permit(:name)
		end
end
