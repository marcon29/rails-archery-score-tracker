Rails.application.routes.draw do

  root "static#home"
  get "about", to: "static#about"

  # get 'login', to: "sessions#new"
  post 'login', to: "sessions#create"
  delete  'logout', to: "sessions#destroy"
  

  resources :rounds, only: [:index, :new, :create]
  resources :score_sessions
  resources :archers, only: [:show, :new, :create, :edit, :update]
  
end
