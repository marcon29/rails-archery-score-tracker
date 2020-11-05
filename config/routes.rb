Rails.application.routes.draw do

  root "static#home"
  # get "home", to: "static#home"
  get "about", to: "static#about"

  resources :rounds, only: [:index, :new, :create]
  resources :score_sessions
  resources :archers, only: [:show, :new, :create, :edit, :update]
  
end
