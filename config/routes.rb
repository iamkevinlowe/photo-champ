Rails.application.routes.draw do

  devise_for :users

  resources :charges, only: [:new, :create]

  root to: 'welcome#index'

end
