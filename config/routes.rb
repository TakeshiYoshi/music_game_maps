Rails.application.routes.draw do
  root to: 'shops#index'
  resources :shops, only: %i[show]
  resource :filter, only: %i[create destroy]
  post 'cities', to: 'filters#cities_select'
end
