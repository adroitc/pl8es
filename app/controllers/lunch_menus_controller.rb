class LunchMenusController < ApplicationController
	
	before_action :authenticate_user
	
	def index
		@lunch_menus = LunchMenu.all
	end
	
	def new
		@lunch_menu = LunchMenu.new
	end
end
