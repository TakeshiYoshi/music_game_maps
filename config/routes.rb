Rails.application.routes.draw do
  root to: 'shops#index'
  resources :shops, only: %i[show] do
    resources :user_reviews, only: %i[create destroy]
  end
  resource :filter, only: %i[create destroy]
  resources :users, only: %i[create show edit update] do
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
  get 'login', to: 'user_sessions#new'
  delete 'logout', to: 'user_sessions#destroy'
  post 'cities', to: 'filters#cities_select'
  post 'near_shops_search', to: 'filters#near_shops_search'
  post 'set_location', to: 'filters#set_location'
  delete 'clear_near_shops_search', to: 'filters#clear_near_shops_search'
  get 'user_policy', to: 'policies#user_policy'
  get 'privacy_policy', to: 'policies#privacy_policy'
  get 'inquiry', to: 'inquiries#inquiry'

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  get '*anithing', to: 'errors#routing_error'
end
