Pl8es::Application.routes.draw do
	
	#app
	resources :app, :only => []
	resources :app_dailycious, :only => []
	resources :app_menumalist, :only => []	
	
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
	
	#web
	resources :web, :only => []
	resources :web_dailycious, :only => []
	
	#web-get
	get "/web/dailycious/list" => "web/dailycious#list"
	
	scope module: :ajax do
		scope :a do
			
			post "/design/edit" => "ajax#editdesign"
			
			#ajax/session
			post "/session/signup/name" => "session#signup_user"
			post "/session/signup/restaurant" => "session#signup_restaurant"
			post "/session/signup/user" => "session#signup_name"
			post "/session/login" => "session#login"
			post "/session/login/forgot" => "session#login_forgot"
			
			#ajax/admin
			post "/language/add" => "admin#addlanguage"
			post "/language/edit" => "admin#editlanguage"
			
			post "/user/edit" => "admin#edituser"
			
			post "/font/add" => "admin#addfont"
			post "/font/edit" => "admin#editfont"
			
			post "/tag/add" => "admin#addcategory"
			post "/tag/edit" => "admin#editcategory"
			
			post "/menucolortemplate/add" => "admin#addmenucolortemplate"
			post "/menucolortemplate/edit" => "admin#editmenucolortemplate"
			
			post "/ingredients/add" => "admin#addingredient"
			post "/ingredients/edit" => "admin#editingredient"
			
			#ajax_dish-post
			post "/buy/dasetupcreditplan" => "payment#dasetupcreditplan"
			
			#ajax_dish-get
			get "/buy/datransfercreditplan" => "payment#datransfercreditplan"
			
			#ajax/profile
			post "/profile/editsettings" => "profile#editsettings"
			post "/profile/editdescription" => "profile#editdescription"
			
			resources :menus, :only => [:create, :update]
			post "/menus/duplicate" => "menus#duplicate"
			post "/menus/resetclients" => "menus#reset_clients", as: :reset_clients
			
			#ajax/navigation
			post "/category/add" => "navigation#addnavigation"
			post "/category/edit" => "navigation#editnavigation"
			post "/category/sort" => "navigation#sortnavigation"
			
			#ajax/dish
			#ajax/dish-get
			get "/dish/:id/:language_locale" => "dish#dish"
			
			#ajax/dish-post
			post "/dish/add" => "dish#adddish"
			post "/dish/edit" => "dish#editdish"
			post "/dish/sort" => "dish#sortdish"
			
			post "/beveragepage/add" => "beverage#addbeveragepage"
			post "/beveragepage/edit" => "beverage#editbeveragepage"
			post "/beveragepage/sort" => "beverage#sortbeveragepage"
			post "/beveragenavigation/add" => "beverage#addbeveragenavigation"
			post "/beveragenavigation/edit" => "beverage#editbeveragenavigation"
			post "/beveragenavigation/sort" => "beverage#sortbeveragenavigation"
			post "/beverage/add" => "beverage#addbeverage"
			post "/beverage/edit" => "beverage#editbeverage"
			post "/beverage/sort" => "beverage#sortbeverage"
			
			#ajax/daily_dish
			post "/dailydish/add" => "daily_dish#adddailydish"
			post "/dailydish/edit" => "daily_dish#editdailydish"
			post "/dailydish/sort" => "daily_dish#sortdailydish"
		end
	end
	
	#signup
	resources :signup, :only => [:index]
	get "/signup/restaurant" => "signup#restaurant"
	get "/signup/user" => "signup#user"
	
	#login
	resources :login, :only => [:index]
	get "/login/forgot" => "login#forgot"
	get "/login/forgot/:user_id/:reset_token" => "login#forgot_reset", as: :login_forgot_reset
	
	#logout
	resources :logout, :only => [:index]
	
	#admin
	resources :admin, :only => [:index]
	scope :admin do
		get "/languages" => "admin#languages"
		get "/users" => "admin#users"
		get "/userswitch/:user_id" => "admin#user_switch", as: :user_switch
		get "/tags" => "admin#categories"
		get "/menucolortemplates" => "admin#menucolortemplates"
		get "/fonts" => "admin#fonts"
		get "/ingredients" => "admin#ingredients"
	end
	
	#dashboard
	resources :dashboard, :path => "/", :only => [:index]
	
	#profile
	resources :profile, :only => [:index]
	get "/restaurant/:restaurant_name/:restaurant_id" => "profile#public" #public
	get "/restaurant" => "profile#index"
	
	#invoice
	resources :invoice, :only => [:index]
	#get "/invoices/invoice/:payment_id" => "invoice#pdf"
	
	#menumalist
	get "/menumalist" => "menumalist#index", as: :menumalist
	get "/menumalist/:menu_title/:menu_id" => "menumalist#categories", as: :show_menu
	get "/menumalist/:menu_title/:menu_id/:navigation_title/:navigation_id" => "menumalist#category", as: :show_navigation
	get "/menumalist/:menu_title/:menu_id/:parent_navigation_title/:parent_navigation_id/:navigation_title/:navigation_id" => "menumalist#category", as: :show_sub_navigation
	
	#beverage
	resources :beverage, :only => []
	get "/menumalist/beverages/:beverage_page_title/:beverage_page_id" => "beverage#beveragepage", as: :show_beverage_page
	get "/menumalist/beverages/:beverage_page_title/:beverage_page_id/:beverage_navigation_title/:beverage_navigation_id" => "beverage#beveragenavigation", as: :show_beverage_navigation
	
	#dailycious
	resources :dailycious, :only => [:index]
	get "/dailycious/:add_weeks-week" => "dailycious#index"
	
end
