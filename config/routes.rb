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
    resources :links, only: [:show, :create, :destroy] do 
      resources :comments, only: [:create, :destroy]
    end
    resources :invites, shallow: true, only: [:show, :create] do
      post 'resend'
    end
  end

  resources :third_parties, only: [:index]
  resource :pocket, controller: "third_parties/pocket", only: [:destroy]
  get 'pocket/authorize', to: 'third_parties/pocket#authorize', as: :authorize_pocket
  get 'pocket/links/add_link' => "third_parties/pocket#add_link" #We have to use a GET request to post link since POST are not well supported from emails  
  
  get   '/custom_sources',            to: 'custom_sources#index'
  get   '/custom_sources/:type/new',  to: 'custom_sources#new', as: :new_custom_source
  get   '/custom_sources/:type/:id/edit',  to: 'custom_sources#edit', as: :edit_custom_source
  put   '/custom_sources/:type/:id',  to: 'custom_sources#update', as: :update_custom_source
  post  '/custom_sources/:type',      to: 'custom_sources#create', as: :create_custom_source
  delete '/custom_sources/:type/:id',      to: 'custom_sources#destroy', as: :destroy_custom_source
  
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: 'sessions#failure'

  if Rails.env.production?
    match '*path', via: :all, to: 'application#error_404'
  end

end
