Rails.application.routes.draw do
  
  resources :score_sessions
  resources :archers, only: [:show, :new, :create, :edit, :update]
  
end
