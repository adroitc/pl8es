class CategoriesController < ApplicationController
	
	before_filter :authenticate_user && :authenticate_ownership_and_get_menu
	before_filter :get_category, only: [:show, :edit, :update, :destroy]
	before_filter :get_languages, only: [:new, :create, :edit, :update]
	
	respond_to :html, :js
	
	def index
		redirect_to menu_path(@menu)
	end
	
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
	
	def show
	end
	
	def edit
	end
	
	def update
		@category.update(category_params)
		
		redirect_to menu_categories_path(@menu)
	end
	
	def destroy
		@category.destroy
		
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
		
		def get_category
			if @menu.categories.exists?(params[:id])
				@category = @menu.categories.find(params[:id])
			else
				redirect_to menu_path(@menu)
			end
		end
		
		def get_languages
			@default_language = @menu.restaurant.default_language
			@languages = @menu.restaurant.languages
		end
	
end
