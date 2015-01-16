class CategoriesController < ApplicationController
	
	before_filter :authenticate_user
	
	def show
		if @user && @user.restaurant.menus.exists?(params[:menu_id]) && @user.restaurant.menus.find(params[:menu_id]).categories.exists?(params[:category_id])
			@category = @user.restaurant.menus.find(params[:menu_id]).categories.find(params[:category_id])
		else
			raise ActionController::RoutingError.new("Not Found")
		end
	end
	
	private
		
		def authenticate_user
			redirect_to login_index_path unless @user
		end
	
end
