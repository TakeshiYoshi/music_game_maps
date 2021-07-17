Rails.application.routes.draw do
  root to: 'shops#index'
  resources :shops, only: %i[show]
  resource :filter, only: %i[create destroy]
  post 'cities', to: 'filters#cities_select'
  post 'set_location', to: 'filters#set_location'
  delete 'clear_location', to: 'filters#clear_location'
end
