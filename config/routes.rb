Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  resources :urls, only: %i(create)
  get '/:token', to: 'urls#open'
  get '/:token/info', to: 'urls#show'
end
