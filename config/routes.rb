# frozen_string_literal: true

Improvcoaches::Application.routes.draw do
  root to: 'home#index'
  get '/about', to: 'home#about'
  get '/splash', to: 'home#splash'
  match '/search', to: 'search#search', via: %i[post get]
  get '/improv-books', to: 'home#resources', as: 'resources'

  controller :auth do
    get  'login' => :new
    post 'login' => :create
    get  'logout' => :destroy

    get 'link' => :link
    post 'link' => :confirm_link
  end

  # Omniauth
  get 'auth/:provider/callback', to: 'auth#create', from_facebook: true
  get 'auth/failure', to: 'auth#failure'
  get 'signout', to: 'auth#destroy', as: 'signout'

  controller :users do
    get 'join' => :new
    get 'profile' => :show, profile: true
    get 'profile/invites' => :invites
    post 'profile/invites' => 'invites#invite_send'
    get 'profile/invites/:code/resend' => 'invites#resend', as: 'profile_invite_resend', defaults: { format: 'js' }
    get 'profile/invites/:code/cancel' => 'invites#cancel', as: 'profile_invite_cancel', defaults: { format: 'js' }
    get 'profile/edit' => :edit
    get 'profile/unlink' => :unlink
    get 'profile/destroy' => :destroy
    get 'profile/edit/improv' => :edit_improv
    get 'profile/edit/schedule' => :edit_schedule
    get 'profile/edit/password' => :edit_password
    post 'profile/update' => :update
    delete 'profile/edit/avatar' => :delete_avatar
  end

  controller :schedules do
    post 'profile/edit/schedule' => :update
  end

  controller :invites do
    get 'invite/:code' => :landing, as: 'invite_landing'
    get 'invite/:code/accept' => :accept, as: 'invite_accept'
  end

  resources :users, path: 'coaches' do
    controller :ratings do
      get 'like' => :like, defaults: {format: :js }
      get 'dislike' => :dislike, defaults: {format: :js }
      get 'bookmark' => :bookmark, defaults: {format: :js }
    end

    get 'email' => :email
    post 'email' => :email_send, defaults: {format: :js }
    post 'comment' => :comment_send, defaults: {format: :js }
  end

  resources :spaces do
    patch 'image' => :add_image
    delete 'image/:id' => :delete_image
  end

  resources :password_resets
  resources :theatres
  resources :substitution_requests
end
