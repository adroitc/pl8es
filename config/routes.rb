Pl8es::Application.routes.draw do
  
  #app
  resources :app, :only => []
  #app-get
  get "/app/dailycious/week" => "app/dailycious#week"
  get "/app/dailycious/defaults" => "app/dailycious#defaults"
  get "/app/dailycious/favorites" => "app/dailycious#favorites"
  get "/app/dailycious/map" => "app/dailycious#map"
  get "/app/dailycious/suggestions" => "app/dailycious#suggestions"
  get "/app/dailycious/search" => "app/dailycious#search"
  get "/app/dailycious/user" => "app/dailycious#user"
  get "/app/menumalist/:user_download_code" => "app#menumalist"
  
  #app-post
  post "/app/dailycious/signup" => "app/dailycious#signup"
  post "/app/dailycious/login" => "app/dailycious#login"
  post "/app/dailycious/profile" => "app/dailycious#profile"
  post "/app/dailycious/add" => "app/dailycious#adddailydish"
  post "/app/dailycious/edit" => "app/dailycious#editdailydish"
  post "/app/dailycious/sort" => "app/dailycious#sortdailydish"
  
  #ajax
  resources :ajax, :only => []
  post "/a/design/edit" => "ajax#editdesign"
  
  #ajax/session
  resources :ajax_session, :only => []
  post "/a/session/signup/name" => "ajax/session#signup_user"
  post "/a/session/signup/restaurant" => "ajax/session#signup_restaurant"
  post "/a/session/signup/user" => "ajax/session#signup_name"
  post "/a/session/login" => "ajax/session#login"
  
  #ajax/admin
  resources :ajax_admin, :only => []
  post "/a/font/add" => "ajax/admin#addfont"
  post "/a/font/edit" => "ajax/admin#editfont"
  
  post "/a/tag/add" => "ajax/admin#addcategory"
  post "/a/tag/edit" => "ajax/admin#editcategory"
  
  post "/a/menucolortemplate/add" => "ajax/admin#addmenucolortemplate"
  post "/a/menucolortemplate/edit" => "ajax/admin#editmenucolortemplate"
  
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
  
  #logout
  resources :logout, :only => []
  get "/logout" => "logout#index"
  
  #admin
  resources :admin, :only => []
  get "/admin" => "admin#index"
  get "/admin/users" => "admin#users"
  get "/admin/userswitch/:user_id" => "admin#user_switch"
  get "/admin/fonts" => "admin#fonts"
  get "/admin/tags" => "admin#categories"
  get "/admin/menucolortemplates" => "admin#menucolortemplates"
  
  #dashboard
  resources :dashboard, :only => []
  get "/" => "dashboard#index"
  
  #profile
  resources :profile, :only => []
  get "/restaurant" => "profile#index"
  
  #menumalist
  resources :menumalist, :only => []
  get "/menumalist" => "menumalist#index"
  get "/menumalist/:menu_id-:menu_title" => "menumalist#categories"
  get "/menumalist/:menu_id-:menu_title/:navigation_id-:navigation_title" => "menumalist#category"
  get "/menumalist/:menu_id-:menu_title/:parent_navigation_id-:parent_navigation_title/:navigation_id-:navigation_title" => "menumalist#category"
  
  #dailycious
  resources :dailycious, :only => []
  get "/dailycious" => "dailycious#index"
  get "/dailycious/:add_weeks-week" => "dailycious#index"
  
end
