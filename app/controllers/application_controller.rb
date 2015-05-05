class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :set_current_locale, :set_device, :verify_restaurant, :set_session
	
	layout :resolve_layout
	
	private
	
		def authenticate_user
			redirect_to new_user_session_path unless current_user
		end
		
		def verify_restaurant
			if current_user && current_user.restaurant.nil?
				redirect_to new_restaurant_path unless controller_name == "restaurants"
			end
		end
		
		def get_languages
			@default_language = current_user.restaurant.default_language
			@languages = current_user.restaurant.languages.order(:id)
		end
		
		def resolve_layout
			if devise_controller?
				'devise'
			else
				'application'
			end
		end
	
		def set_device
			#device
			if Device.validHeader(request.headers)
				device_content = {
					:user => current_user,
					:device_id => request.headers["Device-Id"],
					:device_app => request.headers["Device-App"],
					:device_version => request.headers["Device-Version"],
					:device_type => request.headers["Device-Type"],
					:device_system => request.headers["Device-System"]
				}
				if Device.exists?(:device_id => request.headers["Device-Id"])
					@device = Device.find_by_device_id(request.headers["Device-Id"])
				else
					@device = Device.create()
				end
				@device.update_attributes(device_content)
				if @session
					@session.update_attributes({
						:user => current_user,
						:device => @device
					})
				end
				@device.touch
			end
		end
		
		def set_current_locale
			#language
			if params[:locale]
				I18n.locale = params[:locale]
				if current_user && Language.exists?(:locale => params[:locale])
					current_user.restaurant.update_attributes(:default_language => Language.find(:locale => params[:locale]))
				end
				if session[:signup]
					session[:signup][:locale] = params[:locale]
				end
			elsif !current_user && extract_locale_from_accept_language_header
				I18n.locale = extract_locale_from_accept_language_header
				if session[:signup]
					session[:signup][:locale] = extract_locale_from_accept_language_header
				end
			elsif current_user && current_user.restaurant.present? && current_user.restaurant.default_language.present?
				I18n.locale = current_user.restaurant.default_language.locale
			else
				I18n.locale = :en
			end
		end
		
		def extract_locale_from_accept_language_header
			if request.env['HTTP_ACCEPT_LANGUAGE']
				return request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
			end
			nil
		end
		
		def not_found
			raise ActionController::RoutingError.new('Not found')
		end
	
		def set_session
			#session + request
			if Session.logsSession(session)
				@session = Session.find(session[:user_session_id])
				if !current_user && @session.user
					current_user = @session.user
				end
			elsif request.headers["Token"] && !Session.find_by_token(request.headers["Token"]).blank?
				@session = Session.find_by_token(request.headers["Token"])
				if !currrent_user && @session.user
					current_user = @session.user
				end
				session[:user_session_id] = @session.id
			else
				token = SecureRandom.hex(32).upcase
				while Session.find_by_token(token).present?
					token = SecureRandom.hex(32).upcase
				end
				@session = Session.create({
					:device => @device,
					:token => token,
					:user_agent => request.env["HTTP_USER_AGENT"]
				})
				session[:user_session_id] = @session.id
			end
			unless params[:controller] == "app/dailycious" && params[:action] == "map"
				Request.create(params.permit(:controller, :action).merge({
					:session => @session,
					:params => params.to_json({
						:except => [
							:controller,
							:action,
							:password
						]
					})
				}))
			end
			@session.touch
		end
end
