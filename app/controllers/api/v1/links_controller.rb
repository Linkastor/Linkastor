class Api::V1::LinksController < Api::V1::BaseController
  before_filter :authenticate_user!
  
  def create
    group = Group.find(params[:group_id])
    return render status: 403, json: {error: "You are not authorized to post to this group"} unless current_user.groups.include?(group)
    
    link = group.links.build(link_params)
    if link.save
      render status: 201, json: link
    else
      render status: 422, json: { error: link.errors.full_messages }
    end
  end
  
  protected
    def link_params
      params.require(:link).permit(:title, :url)
    end
end