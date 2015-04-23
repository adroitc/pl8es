Pl8es::Application.routes.draw do
	devise_for :users, :controllers => { :omniauth_callbacks => "authentications" }
	
	namespace :app do
		#app-get
		get "/dailycious/defaults" => "dailycious#defaults"
		get "/dailycious/useragreement" => "dailycious#useragreement"
		get "/dailycious/suggestions" => "dailycious#suggestions"
		get "/dailycious/search" => "dailycious#search"
		get "/dailycious/user" => "dailycious#user"
		
		get "/menumalist/:user_download_code" => "menumalist#index"
		
		#app-post
		post "/dailycious/signup" => "dailycious#signup"
		post "/dailycious/login" => "dailycious#login"
		post "/dailycious/profile" => "dailycious#profile"
	end
	
	scope module: :ajax do
		scope :a do
			
			post "/design/edit" => "ajax#editdesign"
			
			#ajax/admin
			post "/language/add" => "admin#addlanguage"
			post "/language/edit" => "admin#editlanguage"
			
			post "/user/edit" => "admin#edituser"
			
			post "/tag/add" => "admin#add_tag"
			post "/tag/edit" => "admin#edit_tag"
			
			post "/ingredients/add" => "admin#addingredient"
			post "/ingredients/edit" => "admin#editingredient"
			
			#ajax/profile
			post "/profile/editsettings" => "profile#editsettings"
			post "/profile/editdescription" => "profile#editdescription"
			
			#ajax/dish
			#ajax/dish-get
			get "/dish/:id/:language_locale" => "dish#dish"
		end
	end
	
	# menus
	scope :menumalist do
		resources :menus, :path => "/" do
			resources :categories
			
			post "categories/sort" => "categories#sort", as: :sort_categories
			get "categories/:id/crop" => "categories#crop", as: :crop_category
			delete "categories/:id/destroy_image" => "categories#destroy_image", as: :destroy_category_image
		end
		
		post "/resetclients" => "menus#reset_clients", as: :reset_clients
		
		resources :dishes
		post "dishes/sort" => "dishes#sort", as: :sort_dishes
		get "dishes/:id/crop" => "dishes#crop", as: :crop_dish
	end
	
	#admin
	resources :admin, :only => [:index]
	scope :admin do
		get "/languages" => "admin#languages"
		get "/users" => "admin#users"
		get "/userswitch/:user_id" => "admin#user_switch", as: :user_switch
		get "/tags" => "admin#tags"
		get "/ingredients" => "admin#ingredients"
	end
	
	#dashboard
	resources :dashboard, :path => "/", :only => [:index]
	
	#profile
	resources :restaurants
	
	# dailycious
	scope :dailycious do
		get "/:add_weeks-week" => "dailycious#index", as: :dailycious_add_weeks
		
		resources :offers, :path => "/", :only => [:index]
	end
end
