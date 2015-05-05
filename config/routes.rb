Rails.application.routes.draw do
  root to: "application#home"
  
  namespace "api" do
    namespace "v1" do
      post 'users/sign_in', to: 'sessions#create'
    
      resources :groups, only: [:index] do
        resources :links, only: [:create]
      end
      
      #For CORS support
      match "/*path" => "base#options", via: [:options]
    end
  end
  
  resources :users, only: [:edit, :update]
  resources :groups do
    resources :links, only: [:index]
  end
  resources :invites, only: [:show]
  
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: 'sessions#failure'
end
