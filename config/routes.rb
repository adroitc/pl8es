Pl8es::Application.routes.draw do
  
  #app
  resources :app, :only => []
  resources :app_dailycious, :only => []
  resources :app_menumalist, :only => []
  #app-get
  get "/app/dailycious/defaults" => "app/dailycious#defaults"
  get "/app/dailycious/useragreement" => "app/dailycious#useragreement"
  get "/app/dailycious/week" => "app/dailycious#week"
  get "/app/dailycious/favorites" => "app/dailycious#favorites"
  get "/app/dailycious/map" => "app/dailycious#map"
  get "/app/dailycious/suggestions" => "app/dailycious#suggestions"
  get "/app/dailycious/search" => "app/dailycious#search"
  get "/app/dailycious/user" => "app/dailycious#user"
  get "/app/menumalist/:user_download_code" => "app/menumalist#index"
  
  #app-post
  post "/app/dailycious/signup" => "app/dailycious#signup"
  post "/app/dailycious/login" => "app/dailycious#login"
  post "/app/dailycious/profile" => "app/dailycious#profile"
  post "/app/dailycious/add" => "app/dailycious#adddailydish"
  post "/app/dailycious/edit" => "app/dailycious#editdailydish"
  post "/app/dailycious/sort" => "app/dailycious#sortdailydish"
  
  #web
  resources :web, :only => []
  resources :web_dailycious, :only => []
  #web-get
  get "/web/dailycious/list" => "web/dailycious#list"
  
  #ajax
  resources :ajax, :only => []
  post "/a/design/edit" => "ajax#editdesign"
  
  #ajax/session
  resources :ajax_session, :only => []
  post "/a/session/signup/name" => "ajax/session#signup_user"
  post "/a/session/signup/restaurant" => "ajax/session#signup_restaurant"
  post "/a/session/signup/user" => "ajax/session#signup_name"
  post "/a/session/login" => "ajax/session#login"
  post "/a/session/login/forgot" => "ajax/session#login_forgot"
  
  #ajax/admin
  resources :ajax_admin, :only => []
  post "/a/font/add" => "ajax/admin#addfont"
  post "/a/font/edit" => "ajax/admin#editfont"
  
  post "/a/tag/add" => "ajax/admin#addcategory"
  post "/a/tag/edit" => "ajax/admin#editcategory"
  
  post "/a/menucolortemplate/add" => "ajax/admin#addmenucolortemplate"
  post "/a/menucolortemplate/edit" => "ajax/admin#editmenucolortemplate"
  
  post "/a/ingredients/add" => "ajax/admin#addingredient"
  post "/a/ingredients/edit" => "ajax/admin#editingredient"
  
  resources :ajax_payment, :only => []
  #ajax_dish-post
  post "/a/buy/dasetupcreditplan" => "ajax/payment#dasetupcreditplan"
  
  #ajax_dish-get
  get "/a/buy/datransfercreditplan" => "ajax/payment#datransfercreditplan"
  
  #ajax/profile
  resources :ajax_profile, :only => []
  post "/a/profile/editsettings" => "ajax/profile#editsettings"
  post "/a/profile/editdescription" => "ajax/profile#editdescription"
  
  #ajax/menu
  resources :ajax_menu, :only => []
  post "/a/menu/add" => "ajax/menu#addmenu"
  post "/a/menu/edit" => "ajax/menu#editmenu"
  post "/a/menu/duplicate" => "ajax/menu#duplicatemenu"
  
  #ajax/navigation
  resources :ajax_navigation, :only => []
  post "/a/category/add" => "ajax/navigation#addnavigation"
  post "/a/category/edit" => "ajax/navigation#editnavigation"
  post "/a/category/sort" => "ajax/navigation#sortnavigation"
  
  #ajax/dish
  resources :ajax_dish, :only => []
  #ajax/dish-get
  get "/a/dish/:id/:language_locale" => "ajax/dish#dish"
  
  #ajax/dish-post
  post "/a/dish/add" => "ajax/dish#adddish"
  post "/a/dish/edit" => "ajax/dish#editdish"
  post "/a/dish/sort" => "ajax/dish#sortdish"
  
  resources :ajax_beverage, :only => []
  post "/a/beveragepage/add" => "ajax/beverage#addbeveragepage"
  post "/a/beveragepage/edit" => "ajax/beverage#editbeveragepage"
  post "/a/beveragepage/sort" => "ajax/beverage#sortbeveragepage"
  post "/a/beveragenavigation/add" => "ajax/beverage#addbeveragenavigation"
  post "/a/beveragenavigation/edit" => "ajax/beverage#editbeveragenavigation"
  post "/a/beveragenavigation/sort" => "ajax/beverage#sortbeveragenavigation"
  post "/a/beverage/add" => "ajax/beverage#addbeverage"
  post "/a/beverage/edit" => "ajax/beverage#editbeverage"
  post "/a/beverage/sort" => "ajax/beverage#sortbeverage"
  
  #ajax/daily_dish
  resources :ajax_daily_dish, :only => []
  post "/a/dailydish/add" => "ajax/daily_dish#adddailydish"
  post "/a/dailydish/edit" => "ajax/daily_dish#editdailydish"
  post "/a/dailydish/sort" => "ajax/daily_dish#sortdailydish"
  
  #signup
  resources :signup, :only => []
  get "/signup" => "signup#index"
  get "/signup/restaurant" => "signup#restaurant"
  get "/signup/user" => "signup#user"
  
  #login
  resources :login, :only => []
  get "/login" => "login#index"
  get "/login/forgot" => "login#forgot"
  get "/login/forgot/:user_id/:reset_token" => "login#forgot_reset"
  
  #logout
  resources :logout, :only => []
  get "/logout" => "logout#index"
  
  #admin
  resources :admin, :only => []
  get "/admin" => "admin#index"
  get "/admin/users" => "admin#users"
  get "/admin/userswitch/:user_id" => "admin#user_switch"
  get "/admin/tags" => "admin#categories"
  get "/admin/menucolortemplates" => "admin#menucolortemplates"
  get "/admin/fonts" => "admin#fonts"
  get "/admin/ingredients" => "admin#ingredients"
  
  #dashboard
  resources :dashboard, :only => []
  get "/" => "dashboard#index"
  
  #profile
  resources :profile, :only => []
  get "/restaurant/:restaurant_name/:restaurant_id" => "profile#public" #public
  get "/restaurant" => "profile#index"
  
  #invoice
  resources :invoice, :only => []
  get "/invoices/invoice" => "invoice#invoice"
  get "/invoices/invoice_pdf" => "invoice#invoice_pdf"
  
  #menumalist
  resources :menumalist, :only => []
  get "/menumalist" => "menumalist#index"
  get "/menumalist/:menu_title/:menu_id" => "menumalist#categories"
  get "/menumalist/:menu_title/:menu_id/:navigation_title/:navigation_id" => "menumalist#category"
  get "/menumalist/:menu_title/:menu_id/:parent_navigation_title/:parent_navigation_id/:navigation_title/:navigation_id" => "menumalist#category"
  
  #beverage
  resources :beverage, :only => []
  get "/menumalist/beverages/:beverage_page_title/:beverage_page_id" => "beverage#beveragepage"
  get "/menumalist/beverages/:beverage_page_title/:beverage_page_id/:beverage_navigation_title/:beverage_navigation_id" => "beverage#beveragenavigation"
  
  #dailycious
  resources :dailycious, :only => []
  get "/dailycious" => "dailycious#index"
  get "/dailycious/:add_weeks-week" => "dailycious#index"
  
end
