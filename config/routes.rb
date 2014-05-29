Pl8es::Application.routes.draw do
  
  resources :app, :only => []
  get "/app/menumalist/:user_download_code" => "app#menumalist"
  
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
  post "/a/profile/edit" => "ajax/profile#edit"
  
  resources :ajax_menu, :only => []
  post "/a/menu/add" => "ajax/menu#addmenu"
  post "/a/menu/edit" => "ajax/menu#editmenu"
  post "/a/menu/duplicate" => "ajax/menu#duplicatemenu"
  post "/a/menu/delete" => "ajax/menu#deletemenu"
  
  resources :ajax_navigation, :only => []
  post "/a/category/add" => "ajax/navigation#addnavigation"
  post "/a/category/edit" => "ajax/navigation#editnavigation"
  post "/a/category/sort" => "ajax/navigation#sortnavigation"

  resources :ajax_dish, :only => []
  get "/a/dish/:id/:language_locale" => "ajax/dish#dish"
  
  post "/a/dish/add" => "ajax/dish#adddish"
  post "/a/dish/edit" => "ajax/dish#editdish"
  post "/a/dish/sort" => "ajax/dish#sortdish"

  resources :ajax_dish, :only => []
  post "/a/dailydish/add" => "ajax/daily_dish#adddailydish"
  post "/a/dailydish/edit" => "ajax/daily_dish#editdailydish"
  
  resources :signup, :only => []
  get "/signup" => "signup#index"
  
  resources :login, :only => []
  get "/login" => "login#index"
  
  resources :logout, :only => []
  get "/logout" => "logout#index"
  
  resources :admin, :only => []
  get "/admin" => "admin#index"
  get "/admin/users" => "admin#users"
  get "/admin/fonts" => "admin#fonts"
  get "/admin/tags" => "admin#categories"
  get "/admin/menulabels" => "admin#menulabels"
  get "/admin/menucolortemplates" => "admin#menucolortemplates"
  
  resources :profile, :only => []
  get "/restaurant" => "profile#index"
  
  resources :menumalist, :only => []
  get "/menumalist" => "menumalist#index"
  get "/menumalist/:menu_id-:menu_title" => "menumalist#categories"
  get "/menumalist/:menu_id-:menu_title/:navigation_id-:navigation_title" => "menumalist#category"
  get "/menumalist/:menu_id-:menu_title/:parent_navigation_id-:parent_navigation_title/:navigation_id-:navigation_title" => "menumalist#category"
  
  #get "/" => "menumalist#index", :constraints => {:subdomain => "menumalist"}
  
  resources :dailycious, :only => []
  get "/dailycious" => "dailycious#index"
  get "/dailycious/week/:add_weeks" => "dailycious#index"
  
end
