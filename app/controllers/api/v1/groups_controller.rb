class Api::V1::GroupsController < Api::V1::BaseController
  before_filter :authenticate_user!
  
  def index
    render json: current_user.groups
  end
  
end