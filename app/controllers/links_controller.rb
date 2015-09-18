class LinksController < ApplicationController
  before_action :authenticate_current_user!
  before_action :set_link_presenter

  def create
    link_builder = Builders::LinkBuilder.new(params: params, user: current_user)
    link_builder.create_link do |on|
      on.unauthorized do
        flash[:alert] = "You are not authorized to post to this group"
      end
      
      on.created do |link|
        flash[:info] = "Link Posted"
      end
      
      on.already_exist do |link|
        flash[:info] = "Link Reposted"
      end
      
      on.invalid do |link|
        flash[:alert] = link.errors.full_messages.join(". ")
      end
    end

    redirect_to group_url(params[:group_id])
  end

  def show
    @group = Group.find(params[:group_id])
    @link = Link.find(params[:id])
    @comments = Comment.where(link: @link).order(:created_at)
    @comment = Comment.new()
    
    ThirdParties::Pocket::Connection.new(user: current_user).connected? do |on|
      on.connected { @connected_to_pocket = true }
    end
  end

  def destroy
    link = Link.find(params[:id])

    if link.user.id == current_user.id
      link.destroy
    end

    redirect_to group_url(params[:group_id])
  end

  private

  def set_link_presenter
    @link_presenter = LinkPresenter.new
  end
end