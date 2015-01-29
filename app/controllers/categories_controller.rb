class CategoriesController < ApplicationController
	
	before_filter :authenticate_user
	before_filter :authenticate_ownership_and_get_menu
	before_filter :get_languages, :only => [:new, :create, :edit, :update]
	
	def new
		@category = @menu.categories.build
	end
	
	def create
		if !params.values_at(:menu_id, :title, :style).include?(nil) && @user.restaurant.menus.exists?(params[:menu_id])
			menu = @user.restaurant.menus.find(params[:menu_id])
			
			new_category = Category.new(params.permit(:image, :style).merge({
				:menu => menu,
				:position =>menu.categories.unscoped.last != nil ? menu.categories.unscoped.last.id : 0
			}))
			
			if params[:category_id] && menu.categories.exists?(params[:category_id])
				new_category.attributes = {
					:level => 1,
					:category => menu.categories.find(params[:category_id]),
				}
			end
			new_category.save
			
			new_category.image.set_crop_values_for_instance(params.permit(:image))
			
			render :json => {:status => "success", :nav => new_category.errors}
			return
		end
		render :json => {:status => "invalid"}
	end
	
	def edit
		@category = @menu.categories.find(params[:id])
	end
	
	def update
		if !params.values_at(:category_id, :title, :style).include?(nil) && Category.exists?(params[:category_id]) && Category.find(params[:category_id]).menu.restaurant.user == @user
			category = Category.find(params[:category_id])
			
			if params[:delete] == "true"
				category.destroy
			else
				category.update_attributes(params.permit(:image, :style))
				
				category.image.set_crop_values_for_instance(params.permit(:image, :image_crop_w, :image_crop_h, :image_crop_x, :image_crop_y))
			end
				
			render :json => {:status => "success"}
			return
		end
		render :json => {:status => "invalid"}
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
