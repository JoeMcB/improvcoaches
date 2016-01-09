Improvcoaches::Application.routes.draw do
  
  root :to => 'home#index'
  match '/about', :to => 'home#about'
  match '/splash', :to => 'home#splash'
  match '/search', :to => 'search#search'

  controller :auth do
    get  'login' => :new
    post 'login' => :create
    get  'logout' => :destroy

    get "link" => :link
    post "link" => :confirm_link
  end

  #Omniauth
  match 'auth/:provider/callback', to: 'auth#create', from_facebook: true
  match 'auth/failure', to: 'auth#failure'
  match 'signout', to: 'auth#destroy', as: 'signout'


  controller :users do
    get "join" => :new
    get "profile" => :show, profile: true
    get "profile/invites" => :invites
    post "profile/invites" => "invites#invite_send"
    get "profile/invites/:code/resend" => "invites#resend", as: "profile_invite_resend"
    get "profile/invites/:code/cancel" => "invites#cancel", as: "profile_invite_cancel"
    get "profile/edit" => :edit
    get "profile/edit/improv" => :edit_improv
    get "profile/edit/schedule" => :edit_schedule
    get "profile/edit/password" => :edit_password
    post "profile/update" => :update
    put  "profile/update" => :update
    delete "profile/edit/avatar" => :delete_avatar
  end

  controller :schedules do
    post "profile/edit/schedule" => :update
  end

  controller :invites do 
    get "invite/:code" => :landing, as: "invite_landing"
    get "invite/:code/accept" => :accept, as: "invite_accept"
  end


  resources :users, path: "coaches" do
    controller :ratings do
      get "like" => :like
      get "dislike" => :dislike
      get "bookmark" => :bookmark
    end
    
    get "email" => :email
    post "email" => :email_send
    post "comment" => :comment_send
  end

  resources :spaces do
    put "image" => :add_image
    delete "image/:id" => :delete_image
  end

  resources :password_resets
  resources :theatres
  resources :substitution_requests
  



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

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
