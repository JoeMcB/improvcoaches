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

  resources :resources do
    collection do
      get 'books', action: :index, resource_type: 'book'
      get 'dvds', action: :index, resource_type: 'dvd'
      get 'websites', action: :index, resource_type: 'website'
    end
  end


  resources :password_resets
  resources :theatres
  resources :substitution_requests
  

end
