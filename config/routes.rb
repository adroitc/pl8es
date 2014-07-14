Pl8es::Application.routes.draw do
  
  resources :app, :only => []
  get "/app/menumalist/:user_download_code" => "app#menumalist"
  
  #post
  post "/app/dailycious/login" => "app/dailycious#login"
  post "/app/dailycious/add" => "app/dailycious#adddailydish"
  post "/app/dailycious/edit" => "app/dailycious#editdailydish"
  post "/app/dailycious/sort" => "app/dailycious#sortdailydish"
  
  #get
  get "/app/dailycious/week" => "app/dailycious#week"
  get "/app/dailycious/defaults" => "app/dailycious#defaults"
  get "/app/dailycious/favorites" => "app/dailycious#favorites"
  get "/app/dailycious/map" => "app/dailycious#map"
  get "/app/dailycious/suggestions" => "app/dailycious#suggestions"
  get "/app/dailycious/search" => "app/dailycious#search"
  get "/app/dailycious/user" => "app/dailycious#user"
  
  #ajax/session
  resources :ajax_session, :only => []
  post "/a/session/signup" => "ajax/session#signup"
  post "/a/session/login" => "ajax/session#login"
  
  resources :ajax, :only => []
  post "/a/design/edit" => "ajax#editdesign"
  
  resources :ajax_admin, :only => []
  post "/a/font/add" => "ajax/admin#addfont"
  post "/a/font/edit" => "ajax/admin#editfont"
  
  post "/a/tag/add" => "ajax/admin#addcategory"
  post "/a/tag/edit" => "ajax/admin#editcategory"
  
  post "/a/menulabel/add" => "ajax/admin#addmenulabel"
  post "/a/menulabel/edit" => "ajax/admin#editmenulabel"
  
  post "/a/menucolortemplate/add" => "ajax/admin#addmenucolortemplate"
  post "/a/menucolortemplate/edit" => "ajax/admin#editmenucolortemplate"
  
  resources :ajax_profile, :only => []
  post "/a/profile/editsettings" => "ajax/profile#editsettings"
  post "/a/profile/editdescription" => "ajax/profile#editdescription"
  
  resources :ajax_menu, :only => []
  post "/a/menu/add" => "ajax/menu#addmenu"
  post "/a/menu/edit" => "ajax/menu#editmenu"
  post "/a/menu/duplicate" => "ajax/menu#duplicatemenu"
  
  resources :ajax_navigation, :only => []
  post "/a/category/add" => "ajax/navigation#addnavigation"
  post "/a/category/edit" => "ajax/navigation#editnavigation"
  post "/a/category/sort" => "ajax/navigation#sortnavigation"

  resources :ajax_dish, :only => []
  post "/a/dish/add" => "ajax/dish#adddish"
  post "/a/dish/edit" => "ajax/dish#editdish"
  post "/a/dish/sort" => "ajax/dish#sortdish"
  
  get "/a/dish/:id/:language_locale" => "ajax/dish#dish"

  resources :ajax_daily_dish, :only => []
  post "/a/dailydish/add" => "ajax/daily_dish#adddailydish"
  post "/a/dailydish/edit" => "ajax/daily_dish#editdailydish"
  post "/a/dailydish/sort" => "ajax/daily_dish#sortdailydish"
  
  resources :signup, :only => []
  get "/signup" => "signup#index"
  
  resources :login, :only => []
  get "/login" => "login#index"
  
  resources :logout, :only => []
  get "/logout" => "logout#index"
  
  resources :admin, :only => []
  get "/admin" => "admin#index"
  get "/admin/users" => "admin#users"
  get "/admin/userswitch/:user_id" => "admin#user_switch"
  get "/admin/fonts" => "admin#fonts"
  get "/admin/tags" => "admin#categories"
  get "/admin/menucolortemplates" => "admin#menucolortemplates"
  
  resources :dashboard, :only => []
  get "/" => "dashboard#index"
  
  resources :profile, :only => []
  get "/restaurant" => "profile#index"
  
  resources :menumalist, :only => []#, :constraints => {:subdomain => "menumalist"}
  get "/menumalist" => "menumalist#index"
  get "/menumalist/:menu_id-:menu_title" => "menumalist#categories"
  get "/menumalist/:menu_id-:menu_title/:navigation_id-:navigation_title" => "menumalist#category"
  get "/menumalist/:menu_id-:menu_title/:parent_navigation_id-:parent_navigation_title/:navigation_id-:navigation_title" => "menumalist#category"
  
  resources :dailycious, :only => []
  get "/dailycious" => "dailycious#index"
  get "/dailycious/:add_weeks-week" => "dailycious#index"
  
end
