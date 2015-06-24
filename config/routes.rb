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
    resources :links, only: [:create]
    resources :invites, only: [:create]
  end
  resources :invites, only: [:show]
  
  #custom_sources
  get   '/custom_sources',            to: 'custom_sources#index'
  get   '/custom_sources/:type/new',  to: 'custom_sources#new', as: :new_custom_source
  post  '/custom_sources/:type',      to: 'custom_sources#create', as: :create_custom_source
  
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: 'sessions#failure'
end
