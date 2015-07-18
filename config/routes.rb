Rails.application.routes.draw do

  devise_for :users

  resources :charges, only: [:new, :create]
  resources :category
  resources :photo, except: [:edit, :update]

  root to: 'welcome#index'

end
