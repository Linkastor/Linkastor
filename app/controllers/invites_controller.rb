class InvitesController < ApplicationController
  before_action :authenticate_current_user!, only: [:create, :resend]
  def show
    @invite = Invite.where(:code => params[:id]).first!
    session[:invite_id] = @invite.id
  end

  def create
    group = Group.find(params[:group_id])
    request = Invitation::Request.new(referrer: current_user, group: group)
    request.send(emails: params[:emails]) do |on|
      on.invalid_email do |email|
        flash[:alert] = "Could not send an email to #{email} : invalid email address. Please check this email address"
        redirect_to group
      end
      
      on.invite_already_exist do |email|
        flash[:alert] = "Could not send an email to #{email} : invitation already sent. You can resend the invite within the pending invitation list"
        redirect_to group
      end
      
      on.valid_emails do
        flash[:info] = "Invites sent"
        redirect_to group
      end
    end 
  end
  
  def resend
    invite = Invite.find(params[:invite_id])
    Invitation::Request.new.send_emails(invites: [invite])
    flash[:info] = "Invitation was resent to #{invite.email}"
    redirect_to invite.group
  end
end