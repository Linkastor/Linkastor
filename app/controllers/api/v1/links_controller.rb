class Api::V1::LinksController < Api::V1::BaseController
  before_filter :authenticate_user!
  
  def create
    link_builder = Builders::LinkBuilder.new(params: params, user: current_user)
    link_builder.create_link do |on|
      on.unauthorized do
        render status: 403, json: {error: "You are not authorized to post to this group"}
      end
      
      on.created do |link|
        render status: 201, json: link
      end
      
      #If the link already existed in this group we reschedule it for next mail digest
      on.already_exist do |link|
        render status: 200, json: link
      end
      
      on.invalid do |link|
        render status: 422, json: { error: link.errors.full_messages }
      end
    end
  end
end