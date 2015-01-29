class CategoriesController < ApplicationController
	
	before_filter :authenticate_user
	before_filter :authenticate_ownership_and_get_menu
	before_filter :get_languages, :only => [:new, :create, :edit, :update]
	
	def new
		@category = @menu.categories.build
	end
	
	def create
		@category = @menu.categories.new(category_params)
		
		if @category.save
			respond_to do |format|
				format.js
			end
		else
			render :new, :format => :js
		end
	end
	
	def edit
		@category = @menu.categories.find(params[:id])
	end
	
	def update
		if !params.values_at(:category_id, :title, :style).include?(nil) && Category.exists?(params[:category_id]) && Category.find(params[:category_id]).menu.restaurant.user == @user
			category = Category.find(params[:category_id])
			
			category.update_attributes(params.permit(:image, :style))
			
			category.image.set_crop_values_for_instance(params.permit(:image, :image_crop_w, :image_crop_h, :image_crop_x, :image_crop_y))
							
			render :json => {:status => "success"}
			return
		end
		render :json => {:status => "invalid"}
	end
	
	def index
		redirect_to menu_path(@menu)
	end
	
	def sort
		if !params.values_at(:category_ids).include?(nil)
			params[:category_ids].each do |category_id|
				if Category.exists?(category_id[0].to_i) && Category.find(category_id[0].to_i).menu.restaurant.user == @user
					category = Category.find(category_id[0].to_i)
					category.position = category_id[1].to_i
					category.save
				end
			end
			
			render :json => {:status => "success"}
			return
		end
		render :json => {:status => "invalid"}
	end
	
	def show
		if @user && @user.restaurant.menus.exists?(params[:menu_id]) && @user.restaurant.menus.find(params[:menu_id]).categories.exists?(params[:category_id])
			@category = @user.restaurant.menus.find(params[:menu_id]).categories.find(params[:category_id])
		else
			raise ActionController::RoutingError.new("Not Found")
		end
	end
	
	private
		
		def category_params
			params.require(:category).permit(*Category.globalize_attribute_names, :id, :style)
		end
		
		def authenticate_user
			redirect_to login_index_path unless @user
		end
		
		def authenticate_ownership_and_get_menu
			if @user.restaurant.menus.exists?(params[:menu_id])
				@menu = @user.restaurant.menus.find(params[:menu_id])
			else
				redirect_to menus_path
			end
		end
		
		def get_languages
			@default_language = @menu.restaurant.default_language
			@languages = @menu.restaurant.languages
		end
	
end
