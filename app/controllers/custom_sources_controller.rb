class CustomSourcesController < ApplicationController
  before_action :authenticate_current_user!
  before_action :set_custom_source_class, only: [:new, :create]
  
  def index
    @custom_sources = current_user.custom_sources
  end
  
  def new
    @custom_source = @custom_source_class.new
    
    render "custom_sources/#{@type}/new"
  end
  
  def create
    @custom_source = @custom_source_class.new_from_params(params: params)
    
    if @custom_source.save && CustomSourcesUser.create(user: current_user, custom_source: @custom_source)
      redirect_to custom_sources_path, notice: "Your source has been added"
    else
      render new_custom_source_path(type: @type)
    end
  end
  
  private
  def set_custom_source_class
    @type = params[:type]
    @custom_source_class = Object.const_get("CustomSources::#{@type.capitalize}")
  end
end