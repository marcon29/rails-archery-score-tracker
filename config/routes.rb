Rails.application.routes.draw do

  root "static#home"
  get "about", to: "static#about"

  # get 'login', to: "sessions#new"
  post 'login', to: "sessions#create"
  delete  'logout', to: "sessions#destroy"
  
  resources :archers, only: [:show, :new, :create, :edit, :update]
  resources :score_sessions
  
  get '/score_sessions/:id/score', to: 'score_sessions#score', as: 'score'
  patch '/score_sessions/:id/score', to: 'score_sessions#update_score', as: "update_score"


  resources :rounds, only: [:edit, :update]
  # resources :shots, only: [:edit, :update]
  
  
  
end
