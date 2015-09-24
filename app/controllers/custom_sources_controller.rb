class CustomSourcesController < ApplicationController
  before_action :authenticate_current_user!
  before_action :set_custom_source_class, only: [:new, :create, :edit, :update, :destroy]
  
  def index
    @custom_sources = current_user.custom_sources
  end
  
  def new
    @custom_source = @custom_source_class.new(extra: {})
  end

  def edit
    @custom_source = @custom_source_class.find(params[:id])
  end
  
  def create
    @custom_source = @custom_source_class.find_or_initialize(params: params)
    
    if @custom_source.update_from_params(params: params) && CustomSourcesUser.create(user: current_user, custom_source: @custom_source)
      redirect_to custom_sources_path, notice: "Your source has been added"
    else
      render :new
    end
  end

  def update
    @custom_source = @custom_source_class.find(params[:id])
    
    if @custom_source.update_from_params(params: params)
      redirect_to custom_sources_path, notice: "Your source has been updated"
    else
      render :edit, id: @custom_source.to_param
    end
  end

  def destroy
    @custom_sources = current_user.custom_sources
    @custom_source_class.find(params[:id]).destroy
    render :index
  end
  
  private
  def set_custom_source_class
    @type = params[:type]
    @custom_source_class = "CustomSources::#{@type.capitalize}".constantize
  end
end