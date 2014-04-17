Pl8es::Application.routes.draw do
  
  resources :ajax, :only => []
  post "/ajax/signup" => "ajax#signup"
  post "/ajax/login" => "ajax#login"
  
  post "/ajax/addmenu" => "ajax#addmenu"
  post "/ajax/editmenu" => "ajax#editmenu"
  post "/ajax/duplicatemenu" => "ajax#duplicatemenu"
  post "/ajax/deletemenu" => "ajax#deletemenu"

  post "/ajax/addcategory" => "ajax#addnavigation"
  post "/ajax/editcategory" => "ajax#editnavigation"
  post "/ajax/sortcategory" => "ajax#sortnavigation"

  post "/ajax/adddish" => "ajax#adddish"
  
  resources :signup, :only => []
  get "/signup" => "signup#index"
  
  resources :login, :only => []
  get "/login" => "login#index"
  
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
