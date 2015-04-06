class SessionsController < ApplicationController
  def create
    redirect_to '/'
  end
  
  def failure
  end
  
  protected

  def oauth_hash
    request.env['omniauth.auth']
  end
end