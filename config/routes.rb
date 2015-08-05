Rails.application.routes.draw do

  devise_for :users

  resources :users, only: [:show]
  resources :charges, only: [:create]
  get 'cancel_subscription' => 'charges#cancel_subscription'
  resources :categories, except: [:new, :edit]
  resources :photos, except: [:index] do
    resources :comments, only: [:create, :destroy]
    resources :favorites, only: [:create, :destroy]
    resources :reports, only: [:create, :destroy]
  end
  resources :challenges, except: [:edit, :update, :destroy]
  get 'vote' => 'challenges#vote'
  get 'accept' => 'challenges#accept'
  resources :admins, only: [:index] do
    resources :users, only: [:update]
  end
  root to: 'welcome#index'

end
