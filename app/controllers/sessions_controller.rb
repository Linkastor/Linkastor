class SessionsController < ApplicationController
  def create
    user = Oauth::Authorization.new.authorize(oauth_hash: oauth_hash)
    redirect_to edit_user_path(user)
  end
  
  def failure
    flash[:alert] = params[:message]
    redirect_to '/'
  end
  
  protected

  def oauth_hash
    request.env['omniauth.auth']
  end
end