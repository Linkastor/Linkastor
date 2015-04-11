Rails.application.routes.draw do
  root to: "application#home"
  
  resources :users, only: [:edit, :update]
  resources :groups
  resources :invites, only: [:show]
  
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: 'sessions#failure'
end
