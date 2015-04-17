class AdminController < ApplicationController
	
	before_action :authenticate_admin!, :except => [:user_switch]
	
	def index
	end
	
	def languages
	end
	
	def users
	end
	
	def user_switch
		if current_user && (current_user.admin? || (session[:admin_id] && User.exists?(session[:admin_id]) && User.find(session[:admin_id]).admin?))
			session[:user_id] = params[:user_id]
			redirect_to profile_index_path
		else
			not_found
		end
	end
	
	def tags
	end
	
	def ingredients
	end
	
	private
	
		def authenticate_admin!
			not_found unless current_user && current_user.admin?
		end
end
