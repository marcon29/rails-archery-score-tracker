Rails.application.routes.draw do
  
  resources :rounds, only: [:index, :new, :create]
  resources :score_sessions
  resources :archers, only: [:show, :new, :create, :edit, :update]
  
end
