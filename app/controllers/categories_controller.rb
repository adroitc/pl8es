class CategoriesController < ApplicationController
	
	before_filter :authenticate_user && :authenticate_ownership_and_get_menu
	before_filter :get_category, only: [:show, :edit, :update, :crop, :destroy, :destroy_image]
	before_filter :get_languages, only: [:new, :create, :edit, :update, :destroy_image]
	
	respond_to :html, :js
	
	def index
		redirect_to menu_path(@menu)
	end
	
	def new
		@category = @menu.categories.build(new_category_params)
	end
	
	def create
		@category = @menu.categories.new(category_params)
		
		# –– validate parent, has to be root, only one level nesting allowed
		if (@category.parent == @category.root || @category.root?) && @category.save
			if params[:category][:image].present?
				@new_category = true
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
		if @category.update(category_params)
			if params[:category][:image].present?
				@added_image = true
				render :crop
			end
		else
			render :edit
		end
	end
	
	def destroy
		@category.destroy
	end
	
	def destroy_image
		@category.image.destroy
		@category.update(image: nil)
		
		render :edit
	end
	
	def sort
		if params[:category_ids].present?
			params[:category_ids].each do |category_id|
				if @menu.categories.exists?(category_id[0])
					@menu.categories.find(category_id[0]).update(:position => category_id[1].to_i)
				end
			end
			
			render :json => {:status => "success"}
			return
		end
		render :json => {:status => "invalid"}
	end
	
	
	# ––––––––––
	
	
	private
		
		def new_category_params
			params.permit(:parent_id, :menu_id)
		end
		
		def category_params
			params.require(:category).permit(*Category.globalize_attribute_names, :id, :style, :image, :crop_x, :crop_y, :crop_w, :crop_h, :parent_id)
		end
		
		def authenticate_ownership_and_get_menu
			if current_user.restaurant.menus.exists?(params[:menu_id])
				@menu = current_user.restaurant.menus.find(params[:menu_id])
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
	
end
