ButterPecan::Application.routes.draw do

  get "feeder/rss"

  get "pages/gallery" 
  get "pages/archives" 
  get "pages/misc" 
  get "pages/about"

  get "home/index"

  #
  # "main" url shortcuts.
  #
  get "home" => "home#index" 
  get "gallery" =>  "pages#gallery"
  get "archives" => "pages#archives"
  get "misc" =>     "pages#misc"
  get "about" =>    "pages#about"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end
# resources :home do
#   member do
#     get 'get_latest_comic_strip'
#     get :get_latest_comic_strip
#   end
# end
  resources :home do
    collection do
      get 'get_current_comic_info' 
      get 'show_latest'
      get 'show_next'
      get 'show_previous'
      get 'show_first'
      get 'show_random'
      get 'show_current'
    end 
    member do
      get 'get_current_comic_info' 
      get 'show_latest'
      get 'show_next'
      get 'show_previous'
      get 'show_first'
      get 'show_random' 
      get 'show_current' 
    end 
  end


  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  #
  # allow browsing our webcomics by id
  #
  match '(:id)' => 'home#index'

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
