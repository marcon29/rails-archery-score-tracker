Rails.application.routes.draw do
  
  resources :archers, only: [:show, :new, :create, :edit, :update]
  
end
