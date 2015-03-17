class MenusController < ApplicationController
	
	before_filter :authenticate_user
	before_filter :authenticate_ownership_and_get_menu, :only => [:show, :edit, :update, :destroy]
	before_filter :get_languages, :only => [:new]
	
	respond_to :html, :js
	
	def index
		@menus = current_user.restaurant.menus.order(:id)
		
		@restaurant = current_user.restaurant
	end
	
	def new
		@menu = current_user.restaurant.menus.new
	end
	
	def create
		# –– set the defaults
		params[:menu][:from_time] = "12:00" unless params[:menu][:from_time].present?
		params[:menu][:to_time] = "17:00" unless params[:menu][:to_time].present?
		
		restaurant = current_user.restaurant
		
		menu = Menu.new(menu_params)
		
		# –– associations to the restaurant
		restaurant.menus << menu
		restaurant.default_menu = menu if params[:default] == "true" || current_user.restaurant.menus.count == 0
		restaurant.save
		
		redirect_to menus_path
	end
	
	def show
	end
	
	def edit
	end
	
	def update
		@menu.update(menu_params)
		@menu.restaurant.update(:default_menu => @menu) if params[:default] == "true"
		
		redirect_to menus_path
	end
	
	def destroy
		# reassign a default menu
		if @menu.default?
			restaurant = @menu.restaurant
			menus_count = restaurant.menus.count
			
			case
				when menus_count == 1 then restaurant.update(:default_menu => nil)
				when menus_count > 1 then restaurant.update(:default_menu => restaurant.menus.first)
			end
		end
		
		@menu.destroy
		
		redirect_to menus_path
	end
	
	def reset_clients
		if params[:reset] == "true" && (current_user.isAdmin || !current_user.restaurant.client_reset_date || (current_user.restaurant.client_reset_date && (current_user.restaurant.client_reset_date+31.days) < DateTime.now))
			current_user.restaurant.clients.actives.each do |client|
				client.update_attributes(:active => false)
			end
			
			current_user.restaurant.update_attributes(:client_reset_date => DateTime.now)
			
			render :json => {:status => "success"}
			return
		end
		render :json => {:status => "invalid"}
	end
	
	private
		
		def menu_params
			params.require(:menu).permit(:title, :from_time, :to_time)
		end
		
		def authenticate_ownership_and_get_menu
			if current_user.restaurant.menus.exists?(params[:id])
				@menu = current_user.restaurant.menus.find(params[:id])
			else
				redirect_to menus_path
			end
		end
	
end
