Group::Application.routes.draw do
  devise_for :users, only: [:create], :controllers => { :sessions => "sessions" } do
    match '/auth/google_apps/callback', to: 'sessions#create'
    match '/auth/google_apps/android_login', to: 'sessions#create_android'
  end
  match '/users/sign_in' => redirect('/auth/google_apps')
  devise_for :users, except: [:new, :create]

  resources :posts
  resources :users, only: [:index, :show]

  match '/android_login', to: 'android_session#android_login'

  root :to => 'posts#index'
end
