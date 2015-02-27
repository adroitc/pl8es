class DishesController < ApplicationController
	
	before_filter :authenticate_user
	before_filter :get_dish, only: [:show, :edit, :update, :crop, :destroy, :destroy_image]
	before_filter :get_languages, only: [:new, :create, :edit, :update, :destroy_image]
	
	def index
	end
	
	def new
		@dish = Dish.new()
	end
	
	def create
		@dish = @user.restaurant.dishes.build(dish_params)
		
		if @dish.save
			if params[:dish][:image].present?
				@new_dish = true
				render :crop
			end
		else
			render :new
		end
	end
	
	def show
	end
	
	def edit
	end
	
	def update
		if @dish.update(dish_params)
			if params[:dish][:image].present?
				@added_image = true
				render :crop
			end
		else
			render :edit
		end
	end
	
	def destroy
		@dish.destroy
	end
	
	def sort
		if @user && !params.values_at(:dish_ids).include?(nil)
			params[:dish_ids].each do |dish_id|
				if Dish.exists?(dish_id[0].to_i) && Dish.find(dish_id[0].to_i).restaurant.user == @user
					Dish.find(dish_id[0].to_i).update_attributes({
						:position => dish_id[1].to_i
					})
				end
			end
			
			render :json => {:status => "success"}
			return
		end
		render :json => {:status => "invalid"}
	end
	
	private
		
		def dish_params
			params.require(:dish).permit(*Dish.globalize_attribute_names, :price, :image, :crop_x, :crop_y, :crop_w, :crop_h, :ingredient_ids => [])
		end
		
		def get_dish
			if @user.restaurant.dishes.exists?(params[:id])
				@dish = @user.restaurant.dishes.find(params[:id])
			else
				redirect_to menus_path
			end
		end
	
end
