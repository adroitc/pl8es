module Controllers
	module ControllerMacros
		def login_admin
			@request.env["devise.mapping"] = Devise.mappings[:admin]
			sign_in create(:confirmed_admin)
		end
		
		def login_user(user = create(:confirmed_user))
			@request.env["devise.mapping"] = Devise.mappings[:user]
			sign_in user
		end
	end
end