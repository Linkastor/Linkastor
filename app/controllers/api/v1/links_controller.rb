class Api::V1::LinksController < Api::V1::BaseController
  before_filter :authenticate_user!
  
  def create
    group = Group.find(params[:group_id])
    return render status: 403, json: {error: "You are not authorized to post to this group"} unless current_user.groups.include?(group)
    
    #TODO: When we post the same link twice, the link should be marked as not posted
    link = group.links.build(link_params)
    link.posted_by = current_user.id
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