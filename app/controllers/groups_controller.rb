class GroupsController < ApplicationController
  def new
    @group = Group.new
  end
  
  def create
    group = Group.new(group_params)
    if group.save
      Invitation.new(referrer: current_user, group: group).send(params[:emails])
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