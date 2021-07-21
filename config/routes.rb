Rails.application.routes.draw do
  root to: 'shops#index'
  resources :shops, only: %i[show]
  resource :filter, only: %i[create destroy]
  resources :users, only: %i[create]
  get 'signup', to: 'users#new'
  post 'cities', to: 'filters#cities_select'
  post 'near_shops_search', to: 'filters#near_shops_search'
  post 'set_location', to: 'filters#set_location'
  delete 'clear_near_shops_search', to: 'filters#clear_near_shops_search'
end
