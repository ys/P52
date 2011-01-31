P52::Application.routes.draw do

  root :to => "home#index"
  
  resources :projects, :except =>[:show,:index], :constraints => { :id => /.*/ }  do
    member do
        put 'archive'
    end
    get 'admin', :on => :collection
    resources :pictures, :only =>[:new]
  end 
  resources :pictures, :except =>[:index] do
    get 'admin', :on => :collection
  end
  match '/pictures' => 'pictures#globalIndex'
  match '/projects' => 'projects#globalIndex'
  resources :authentications

  devise_for :users
  
  resources :users, :only => [:show, :index], :constraints => { :id => /.*/ } do
    resources :projects, :only =>[:show,:index], :constraints => { :id => /.*/ } do
      get 'feed'
    end
    resources :pictures, :only =>[:index, :show]
  end
  #match '/users' => 'users#index'
  #match '/:id' => 'users#show'
  #match '/:user_id/projects' => 'projects#index'
  #match '/:user_id/projects/:id' => 'projects#show'
  #match '/:user_id/pictures' => 'pictures#index'
  #match '/:user_id/pictures/:id' => 'pictures#show'
  match '/account' => 'users#account'
  match '/users/:id/:size' => 'users#current_project', :constraints => { :id => /.*/ }
  match '/users/:id/recent_tweets' => 'users#recent_tweets', :constraints => { :id => /.*/ }
  match '/users/:id/last_pictures' => 'users#last_pictures', :constraints => { :id => /.*/ }
  match '/users/:id/galleries' => 'users#galleries', :constraints => { :id => /.*/ }
  match '/auth/:provider/callback' => 'authentications#create'
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

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
