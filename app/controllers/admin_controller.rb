class AdminController < ApplicationController
	
	before_filter :authenticate_admin!, :except => [:user_switch]
	
	def index
	end
	
	def languages
	end
	
	def users
	end
	
	def user_switch
		if current_user && (current_user.isAdmin || (session[:admin_id] && User.exists?(session[:admin_id]) && User.find(session[:admin_id]).isAdmin))
			session[:user_id] = params[:user_id]
			redirect_to profile_index_path
		else
			raise ActionController::RoutingError.new("Not Found")
		end
	end
	
	def tags
	end
	
	def menucolortemplates
	end
	
	def fonts
	end
	
	def ingredients
	end
	
	private
	
		def authenticate_admin!
			raise ActionController::RoutingError.new("Not Found") unless current_user && current_user.isAdmin
		end
end
