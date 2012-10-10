Group::Application.routes.draw do
  devise_for :users, only: [:create], :controllers => { :sessions => "sessions" } do
    match '/auth/google_apps/callback', to: 'sessions#create'
    match '/auth/google_apps/android_login', to: 'sessions#create_android'
  end
  match '/users/sign_in' => redirect('/auth/google_apps')
  devise_for :users, except: [:new, :create]

  namespace 'api' do
    namespace 'v1' do
      resources :posts, except: [:create, :edit]
      resources :users, only: [:index, :show]
    end
  end

  resources :users, only: [:index, :show]
  resources :posts

  match '/android_login', to: 'android_session#android_login'

  root :to => 'posts#index'

  # For tests only.
  devise_scope :user do
    match '/test/users_sign_in', to: 'sessions#test_create'
  end
end
