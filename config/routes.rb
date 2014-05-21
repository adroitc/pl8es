Pl8es::Application.routes.draw do
  
  resources :app, :only => []
  get "/app/menumalist/:user_download_code" => "app#menumalist"
  
  #ajax/session
  resources :ajax_session, :only => []
  post "/a/session/signup" => "ajax/session#signup"
  post "/a/session/login" => "ajax/session#login"
  
  resources :ajax, :only => []
  post "/a/design/edit" => "ajax#editdesign"
  
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
  
  resources :signup, :only => []
  get "/signup" => "signup#index"
  
  resources :login, :only => []
  get "/login" => "login#index"
  
  resources :profile, :only => []
  get "/profile" => "profile#index"
  
  resources :menumalist, :only => []
  get "/menumalist" => "menumalist#index"
  get "/menumalist/:menu_title-:menu_id" => "menumalist#categories"
  get "/menumalist/:menu_title-:menu_id/:navigation_title-:navigation_id" => "menumalist#category"
  get "/menumalist/:menu_title-:menu_id/:parent_navigation_title-:parent_navigation_id/:navigation_title-:navigation_id" => "menumalist#category"
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
