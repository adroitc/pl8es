class MenusController < ApplicationController
	
	before_filter :authenticate_user
	before_filter :authenticate_ownership_and_get_menu, :only => [:show, :edit, :update, :destroy]
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
	end
	
	def edit
	end
	
	def update
		@menu.update(menu_params)
		@menu.restaurant.update(:defaultMenu => @menu) if params[:default] == "true"
		
		redirect_to menus_path
	end
	
	def destroy
		# reassign a default menu
		if @menu.default?
			restaurant = @menu.restaurant
			menus_count = restaurant.menus.count
			
			case
				when menus_count == 1 then restaurant.update(:defaultMenu => nil)
				when menus_count > 1 then restaurant.update(:defaultMenu => restaurant.menus.first)
			end
		end
		
		@menu.destroy
		
		redirect_to menus_path
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
		
		def authenticate_ownership_and_get_menu
			if @user.restaurant.menus.exists?(params[:id])
				@menu = @user.restaurant.menus.find(params[:id])
			else
				redirect_to menus_path
			end
		end
	
end
