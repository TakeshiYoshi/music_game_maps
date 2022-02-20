Rails.application.routes.draw do
  root to: 'shops#index'
  resources :shops, only: %i[show] do
    resources :user_reviews, only: %i[create destroy]
    resources :shop_histories, only: %i[new create]
  end
  resource :filter, only: %i[create destroy]
  resources :users, only: %i[create show edit update destroy] do
    scope module: :users do
      resource :profile, only: %i[edit update]
    end

    member do
      get :activate
      get :edit_profile
      post :update_profile
    end
  end
  resources :password_resets, only: %i[new create update edit]
  resources :user_sessions, only: %i[create]
  resource :theme, only: %i[create]
  get 'signup', to: 'users#new'
  get 'signup_with_twitter', to: 'users#new_with_twitter'
  post 'create_users_with_twitter', to: 'users#create_with_twitter'
  get 'login', to: 'user_sessions#new'
  delete 'logout', to: 'user_sessions#destroy'
  post 'cities', to: 'filters#cities_select'
  post 'near_shops_search', to: 'filters#near_shops_search'
  post 'set_location', to: 'filters#set_location'
  delete 'clear_near_shops_search', to: 'filters#clear_near_shops_search'
  get 'user_policy', to: 'policies#user_policy'
  get 'privacy_policy', to: 'policies#privacy_policy'
  get 'inquiry', to: 'inquiries#inquiry'
  post 'oauth/callback', to: 'oauths#callback'
  get 'oauth/callback', to: 'oauths#callback'
  get 'oauth/:provider', to: 'oauths#oauth', as: :auth_at_provider

  namespace :admin do
    root 'dashboards#index'
    resources :users, only: %i[index destroy]
    resources :shops, only: %i[index show edit update destroy]
    resources :user_reviews, only: %i[index destroy]
    resources :shop_histories, only: %i[index update destroy]
  end

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  get '*anithing', to: 'errors#routing_error'
end
