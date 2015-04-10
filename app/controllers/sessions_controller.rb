class SessionsController < ApplicationController
  def create
    user = Oauth::Authorization.new.authorize(oauth_hash: oauth_hash)
    
    if session[:invite_id].present?
      confirmation = Invitation::Confirmation.new(invite: Invite.find(session[:invite_id]),
                                    referee: user)
      confirmation.accept!
      return redirect_to groups_path
    end
    
    redirect_to edit_user_path(user)
  end
  
  def failure
    flash[:alert] = params[:message]
    redirect_to '/', alert: 'twitter authentication failed'
  end
  
  protected

  def oauth_hash
    request.env['omniauth.auth']
  end
end