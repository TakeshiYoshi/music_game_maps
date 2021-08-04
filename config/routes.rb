Rails.application.routes.draw do
  root to: 'shops#index'
  resources :shops, only: %i[show]
  resource :filter, only: %i[create destroy]
  resources :users, only: %i[create show] do
    member do
      get :activate
    end
  end
  resources :password_resets, only: %i[new create update edit]
  resources :user_sessions, only: %i[create]
  get 'signup', to: 'users#new'
  get 'login', to: 'user_sessions#new'
  delete 'logout', to: 'user_sessions#destroy'
  post 'cities', to: 'filters#cities_select'
  post 'near_shops_search', to: 'filters#near_shops_search'
  post 'set_location', to: 'filters#set_location'
  delete 'clear_near_shops_search', to: 'filters#clear_near_shops_search'

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
