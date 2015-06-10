class GroupsController < ApplicationController
  before_action :authenticate_current_user!
  
  def index
    @title = 'Your groups'
    @groups = current_user.groups
  end
  
  def new
    @group = Group.new
  end
  
  def edit
    @group = Group.find(params[:id])
  end
  
  def update
    @group = Group.find(params[:id])
    valid_group = @group.update_attributes(group_params)
    return render 'edit' unless valid_group
    
    send_invites
  end
  
  def create
    @group = Group.new(group_params)
    @group.users = [current_user]
    valid_group = @group.save
    return render 'new' unless valid_group
    
    send_invites
  end

  def show
    @group = Group.find(params[:id])
    @title = @group.name
    @token = Authentication::Token.new(user: current_user).create
  end

  private
    def send_invites
      @group.emails = params[:group][:emails]
      request = Invitation::Request.new(referrer: current_user, group: @group)
      request.send(emails: @group.emails) do |on|
        on.invalid_email do |email|
          flash[:alert] = "Could not send an email to #{email} : invalid email address or invitation already sent. Please fix or remove this email address"
          return render 'edit'
        end
        
        on.valid_emails do
          flash[:info] = "Group #{@group.name} was created"
          return redirect_to groups_url
        end
      end
    end
  
    def group_params
      params.require(:group).permit(:name)
    end
end
