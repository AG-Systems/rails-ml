Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, controllers: { registrations: "registrations" }
  root 'pages#index'
  get 'support' => 'pages#support'
  get 'about' => 'pages#about'
  get 'subscribers' => 'subscribers#new'
  get 'upload' => 'pages#new'
  get 'terms' => 'pages#terms'
  get 'error' => 'ads#error'
  get 'results' => 'pages#results' 
  get 'privacy' => 'pages#privacy'
  resources :accounts
  resources :subscribers
  resources :ads
  if Rails.env.production?
     get '404', :to => 'pages#page_not_found'
  end
end
