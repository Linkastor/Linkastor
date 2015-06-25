class InvitesController < ApplicationController
  def show
    @invite = Invite.where(:code => params[:id]).first!
    session[:invite_id] = @invite.id
  end

  def create
    group = Group.find(params[:group_id])
    request = Invitation::Request.new(referrer: current_user, group: group)
    request.send(emails: params[:emails]) do |on|
      on.invalid_email do |email|
        flash[:alert] = "Could not send an email to #{email} : invalid email address or invitation already sent. Please fix or remove this email address"
        redirect_to group_url(params[:group_id], :invalid_emails => params[:emails])
      end
      
      on.valid_emails do
        flash[:info] = "Invites sent"
        redirect_to group_url(params[:group_id])
      end
    end 
  end
end