class AuthenticationsController < Devise::OmniauthCallbacksController
	def facebook
		omni = request.env["omniauth.auth"]
		
		authentication = Authentication.find_by_provider_and_uid(omni.provider, omni.uid)
		
		if authentication
			authentication.save
			
			set_flash_message(:notice, :signed_in)
			sign_in_and_redirect authentication.user
		elsif current_user
			current_user.authentications.create(provider: omni.provider, uid: omni.uid)
			flash[:notice] = "Authentication successful."
		else
			user = User.find_by_email(omni.info.email) || User.new(email: omni.info.email, password: Devise.friendly_token[0,20])
			user.authentications.new(provider: omni.provider, uid: omni.uid)
			
			user.skip_confirmation!
			if user.save
				sign_in_and_redirect user
				flash[:notice] = "Signed up successfully via Facebook"
			else
				session[:omniauth] = omni.except(:extra)
				redirect_to root_url
			end
		end
	end
end