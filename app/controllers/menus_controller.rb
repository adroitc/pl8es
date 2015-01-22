class MenusController < ApplicationController
	
	before_filter :authenticate_user
	respond_to :html, :js
	
	def index
		@menus = @user.restaurant.menus.order(:id)
		
		@restaurant = @user.restaurant
	end
	
	def new
		@menu = @user.restaurant.menus.new
		@languages = @user.restaurant.languages.order(:title)
	end
	
	def create
		# –– set the defaults
		params[:menu][:from_time] = "12:00" unless params[:menu][:from_time].present?
		params[:menu][:to_time] = "17:00" unless params[:menu][:to_time].present?
		
		restaurant = @user.restaurant
		
		menu = Menu.new(menu_params)
		
		# –– associations to the restaurant
		restaurant.menus << menu
		restaurant.defaultMenu = menu if params[:default] == "true" || @user.restaurant.menus.count == 0
		restaurant.save
		
		redirect_to menus_path
	end
	
	def show
		@menu = @user.restaurant.menus.find(params[:id])
	end
	
	def edit
		@menu = @user.restaurant.menus.find(params[:id])
	end
	
	def update
		menu = @user.restaurant.menus.find(params[:id])
		menu.update(menu_params)
		
		if params[:default] == "true"
			restaurant = menu.restaurant
			restaurant.defaultMenu = menu
			restaurant.save
		end
		
		redirect_to menus_path
	end
	
	def destroy
		
	end
	
	def reset_clients
		if params[:reset] == "true" && (@user.isAdmin || !@user.restaurant.client_reset_date || (@user.restaurant.client_reset_date && (@user.restaurant.client_reset_date+31.days) < DateTime.now))
			@user.restaurant.clients.actives.each do |client|
				client.update_attributes(:active => false)
			end
			
			@user.restaurant.update_attributes(:client_reset_date => DateTime.now)
			
			render :json => {:status => "success"}
			return
		end
		render :json => {:status => "invalid"}
	end
	
	private
		
		def menu_params
			params.require(:menu).permit(:title, :from_time, :to_time)
		end
		
		def authenticate_user
			redirect_to login_index_path unless @user
		end
	
end
