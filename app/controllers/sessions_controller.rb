class SessionsController < ApplicationController
  def create
    user = Oauth::Authorization.new.authorize(oauth_hash: oauth_hash)
    invite = Invitation::InvitationFactory.new(invite_id: session[:invite_id]).invite
    
    if invite
      confirmation = Invitation::Confirmation.new(invite: invite,
                                                  referee: user)
      confirmation.accept!
      return redirect_to groups_path
    end
    
    session[:user_id] = user.id
    
    if user.email
      redirect_to groups_path(user)
    else
      redirect_to edit_user_path(user)
    end
    
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