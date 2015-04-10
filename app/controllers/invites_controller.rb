class InvitesController < ApplicationController
  def show
    @invite = Invite.where(:code => params[:id]).first!
    session[:invite_id] = @invite.id
  end
end