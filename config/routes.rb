Rails.application.routes.draw do
  root to: 'shops#index'
  resources :shops, only: %i[show]
end
