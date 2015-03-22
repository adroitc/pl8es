Pl8es::Application.routes.draw do
	devise_for :users, :controllers => { :omniauth_callbacks => "authentications" }
	
	namespace :app do
		#app-get
		get "/dailycious/defaults" => "dailycious#defaults"
		get "/dailycious/useragreement" => "dailycious#useragreement"
		get "/dailycious/week" => "dailycious#week"
		get "/dailycious/favorites" => "dailycious#favorites"
		get "/dailycious/map" => "dailycious#map"
		get "/dailycious/suggestions" => "dailycious#suggestions"
		get "/dailycious/search" => "dailycious#search"
		get "/dailycious/user" => "dailycious#user"
		
		get "/menumalist/:user_download_code" => "menumalist#index"
		
		#app-post
		post "/dailycious/signup" => "dailycious#signup"
		post "/dailycious/login" => "dailycious#login"
		post "/dailycious/profile" => "dailycious#profile"
		post "/dailycious/add" => "dailycious#adddailydish"
		post "/dailycious/edit" => "dailycious#editdailydish"
		post "/dailycious/sort" => "dailycious#sortdailydish"
	end
	
	#web-get
	get "/web/dailycious/list" => "web/dailycious#list"
	
	scope module: :ajax do
		scope :a do
			
			post "/design/edit" => "ajax#editdesign"
			
			#ajax/admin
			post "/language/add" => "admin#addlanguage"
			post "/language/edit" => "admin#editlanguage"
			
			post "/user/edit" => "admin#edituser"
			
			post "/font/add" => "admin#addfont"
			post "/font/edit" => "admin#editfont"
			
			post "/tag/add" => "admin#add_tag"
			post "/tag/edit" => "admin#edit_tag"
			
			post "/menucolortemplate/add" => "admin#addmenucolortemplate"
			post "/menucolortemplate/edit" => "admin#editmenucolortemplate"
			
			post "/ingredients/add" => "admin#addingredient"
			post "/ingredients/edit" => "admin#editingredient"
			
			#ajax/profile
			post "/profile/editsettings" => "profile#editsettings"
			post "/profile/editdescription" => "profile#editdescription"
			
			#ajax/dish
			#ajax/dish-get
			get "/dish/:id/:language_locale" => "dish#dish"
			
			#ajax/daily_dish
			post "/dailydish/add" => "daily_dish#adddailydish"
			post "/dailydish/edit" => "daily_dish#editdailydish"
			post "/dailydish/sort" => "daily_dish#sortdailydish"
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
		get "/menucolortemplates" => "admin#menucolortemplates"
		get "/fonts" => "admin#fonts"
		get "/ingredients" => "admin#ingredients"
	end
	
	#dashboard
	resources :dashboard, :path => "/", :only => [:index]
	
	#profile
	resources :profile, :only => [:index]
	get "/restaurant/:restaurant_name/:restaurant_id" => "profile#restaurant"
	
	#dailycious
	get "/dailycious" => "dailycious#index"
	get "/dailycious/:add_weeks-week" => "dailycious#index", as: :dailycious_add_weeks
	
end
