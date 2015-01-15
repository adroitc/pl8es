class Ajax::MenusController < ApplicationController
	
	def create
		if @user && !params.values_at(:title, :default_language).include?(nil) && Language.exists?(params[:default_language].to_i)
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
			
			params[:from_time] = "12:00" if !params[:from_time]
			params[:to_time] = "17:00" if !params[:to_time]
			
			new_menu = Menu.create(params.permit(:title, :from_time, :to_time).merge({
				:default_language => Language.find(params[:default_language].to_i),
				:languages => languages,
				:restaurant => @user.restaurant
			}))
			if params[:default] == "true" || @user.restaurant.menus.count == 0
				@user.restaurant.update_attributes({
					:defaultMenu => new_menu
				})
			end
			
			render :json => {:status => "success", :p => params}
			return
		end
		render :json => {:status => "invalid"}
	end
	
	def update
		if @user && !params.values_at(:id, :title, :default_language).include?(nil) && @user.restaurant.menus.exists?(params[:id]) && Language.exists?(params[:default_language].to_i)
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
	
	def duplicate
		if @user && !params.values_at(:menu_id).include?(nil) && @user.restaurant.menus.exists?(params[:menu_id])
			menu = @user.restaurant.menus.find(params[:menu_id])
			
			dup_menu = menu.dup
			dup_menu.title = menu.title+" 2"
			dup_menu.save
			
			render :json => {:status => "success"}
			return
		end
		render :json => {:status => "invalid"}
	end
	
	def reset_clients
		if @user && !params.values_at(:reset).include?(nil) && params[:reset] == "true" && (@user.isAdmin || !@user.restaurant.client_reset_date || (@user.restaurant.client_reset_date && (@user.restaurant.client_reset_date+31.days) < DateTime.now))
			@user.restaurant.clients.actives.each do |client|
				client.update_attributes(:active => false)
			end
			@user.restaurant.update_attributes(:client_reset_date => DateTime.now)
			
			render :json => {:status => "success"}
			return
		end
		render :json => {:status => "invalid"}
	end
	
end
