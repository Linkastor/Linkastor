class GroupsController < ApplicationController
  before_action :authenticate_current_user!
  
  def index
  end
  
  def new
    @group = Group.new
  end
  
  def create
    group = Group.new(group_params)
    if group.save
      Invitation::Request.new(referrer: current_user, group: group).send(emails: params[:emails])
      redirect_to groups_url, info: "Group #{group.name} was created"
    else
      return render 'new'
    end
  end
  
  private
    def group_params
      params.require(:group).permit(:name)
    end
end