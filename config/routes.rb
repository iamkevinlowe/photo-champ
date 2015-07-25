Rails.application.routes.draw do

  devise_for :users

  resources :users, only: [:show]
  resources :charges, only: [:create]
  get 'cancel_subscription' => 'charges#cancel_subscription'
  resources :categories, except: [:new, :edit]
  resources :photos, except: [:index]
  resources :challenges, only: [:show]

  root to: 'welcome#index'

end
