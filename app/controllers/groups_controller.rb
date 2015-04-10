class GroupsController < ApplicationController
  before_action :authenticate_current_user!
  
  def index
  end
  
  def new
    @group = Group.new
  end
  
  def create
    group = Group.new(group_params)
    valid_group = group.save
    return render 'new' unless valid_group
    
    request = Invitation::Request.new(referrer: current_user, group: group)
    request.send(emails: params[:emails]) do |on|
      on.invalid_email do |email|
        return render 'new', alert: "Could not send an email to #{email}, please enter a valid email address"
      end
      
      on.valid_emails do
        return redirect_to groups_url, info: "Group #{group.name} was created"
      end
    end
  end
  
  private
    def group_params
      params.require(:group).permit(:name)
    end
end