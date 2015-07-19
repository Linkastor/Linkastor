class CommentsController < ApplicationController
  before_action :authenticate_current_user!

  def create
    comment = Comment.new(:content => params[:comment][:content])
    comment.link_id = params[:link_id]
    comment.user = current_user

    comment.save

    redirect_to group_link_path(params[:group_id], params[:link_id])
  end
end