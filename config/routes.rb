Rails.application.routes.draw do

 # get 'users/new'
 get 'home_admin' => 'static_pages#home_admin'
 get 'lecture_search' => 'static_pages#search'
 get 'newsfeed' => 'static_pages#newsfeed'
 get 'rank' => 'static_pages#rank'

 get 'usage' => 'static_pages#menual'
 get 'notice' => 'static_pages#notice'

 get 'login_form' => 'static_pages#login_form'
 get 'home' => 'static_pages#home'
 root 'static_pages#daemoon'

 get 'forcinglogin' => 'static_pages#forcinglogin'
 get 'forcingwritting' =>'static_pages#forcingwritting'


  get 'signup'  => 'users#new'

 get    'login'   => 'sessions#new'
 post   'login'   => 'sessions#create'
 delete 'logout'  => 'sessions#destroy'

 post 'timetables/make_a_change' => 'timetables#make_a_change'
 delete 'delete_timetable' => 'timetables#destroy'
 post 'add_timetable' => 'timetables#create'
#resources :lectures
resources :users do
   member { get :timetable }
end 


match 'auth/:provider/callback', :controller => 'sessions', action: 'create_by_facebook', via: [:get, :post]
match 'auth/failure', to: redirect('/'), via: [:get, :post]
match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]
resources :lectures do
  collection { post :import }
  
  member { get :writtingform }
end


resources :valuations, only: [:create, :destroy, :edit, :update]
resources :comments, only: [:create, :destroy, :edit, :update]
resources :comment_valuations, only: [:create, :destroy]

#match ":url" => "application#redirect_user", :constraints => { :url => /.*/ }


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