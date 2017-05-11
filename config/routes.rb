Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, controllers: { registrations: "registrations" }
  root 'pages#index'
  get 'support' => 'pages#support'
  get 'about' => 'pages#about'
  get 'subscribers' => 'subscribers#new'
  get 'upload' => 'pages#new'
  get 'terms' => 'pages#terms'
  resources :accounts
  resources :subscribers
  resources :ads
end
