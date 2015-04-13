Rails.application.routes.draw do
  root to: "application#home"
  
  namespace "api" do
    namespace "v1" do
      post 'users/sign_in', to: 'sessions#create'
      
      #For CORS support
      match "/*path" => "base#options", via: [:options]
    end
  end
  
  resources :users, only: [:edit, :update]
  resources :groups
  resources :invites, only: [:show]
  
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: 'sessions#failure'
end
