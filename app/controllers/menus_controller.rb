class MenusController < ApplicationController
	
	before_filter :authenticate_user
	
	def index
		@menus = @user.restaurant.menus.all
		
		@restaurant = @user.restaurant
	end
	
	def new
		@menu = @user.restaurant.menus.new
		@languages = @user.restaurant.languages.order(:title)
		
		respond_to do |format|
			format.js
		end
	end
	
	def create
		# –– set the defaults
		params[:menu][:from_time] = "12:00" unless params[:menu][:from_time].present?
		params[:menu][:to_time] = "17:00" unless params[:menu][:to_time].present?
		
		restaurant = @user.restaurant
		
		menu = Menu.new(menu_params)
		
		# –– associations to the restaurant
		restaurant.menus << menu
		restaurant.defaultMenu = menu if params[:default] == "1" || @user.restaurant.menus.count == 0
		
		restaurant.save
		
		redirect_to menus_path
	end
	
	def show
		@menu = @user.restaurant.menus.find(params[:id])
	end
	
	def update
		if !params.values_at(:id, :title, :default_language).include?(nil) && @user.restaurant.menus.exists?(params[:id]) && Language.exists?(params[:default_language].to_i)
			menu = @user.restaurant.menus.find(params[:id])
			
			if params[:delete] == "true"
				menu.destroy
			else
				languages = Array.new
				if params[:languages]
					params[:languages].each do |language|
						if Language.exists?(language[0].to_i)
							languages.push(Language.find(language[0].to_i))
						end
					end
				end
				if !languages.include?(Language.find(params[:default_language].to_i))
					languages.push(Language.find(params[:default_language].to_i))
				end
				
				menu.update_attributes(params.permit(:title, :from_time, :to_time).merge({
					:default_language => Language.find(params[:default_language].to_i),
					:languages => languages,
				}))
				if params[:default] == "true"
					@user.restaurant.update_attributes({
						:defaultMenu => menu
					})
				end
			end
			
			render :json => {:status => "success"}
			return
		end
		render :json => {:status => "invalid"}
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
