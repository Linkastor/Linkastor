class SessionsController < ApplicationController
  def create
    user = Oauth::Authorization.new.authorize(oauth_hash: oauth_hash)
    redirect_to edit_user_path(user)
  end
  
  def add_email
    
  end
  
  def failure
  end
  
  protected

  def oauth_hash
    request.env['omniauth.auth']
  end
end