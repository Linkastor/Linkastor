class SessionsController < ApplicationController
  def create
    user = Oauth::Authorization.new.authorize(oauth_hash: oauth_hash)
    invite = Invitation::InvitationFactory.new(invite_id: session[:invite_id]).invite
    
    if invite
      confirmation = Invitation::Confirmation.new(invite: invite,
                                                  referee: user)
      confirmation.accept! do |on|
        on.group_invalid do
          flash[:alert] = "The group you were invited to doesn't exist anymore"
          session.delete(:invite_id)
        end
        
        on.success do |group|
          flash[:info] = "You have successfully joined the group #{group.name}"
          session.delete(:invite_id)
        end
      end
        
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