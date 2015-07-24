Rails.application.routes.draw do

  devise_for :users

  resources :users, only: [:show]
  resources :charges, only: [:new, :create]
  resources :categories
  resources :photos, except: [:index]
  resources :challenges, only: [:show]

  root to: 'welcome#index'

end
