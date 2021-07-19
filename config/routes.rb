Rails.application.routes.draw do
  root to: 'shops#index'
  resources :shops, only: %i[show]
  resource :filter, only: %i[create destroy]
  post 'cities', to: 'filters#cities_select'
  post 'near_shops_search', to: 'filters#near_shops_search'
  delete 'clear_near_shops_search', to: 'filters#clear_near_shops_search'
  post 'set_location', to: 'filters#set_location'
end
