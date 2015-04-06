Rails.application.routes.draw do
  root to: "application#home"

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: 'sessions#failure'
end
