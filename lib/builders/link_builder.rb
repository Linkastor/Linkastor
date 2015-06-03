module Builders
  class LinkBuilder
    def initialize(params:, user:)
      @params = params
      @user = user
      @callback = Callback.new
    end
    
    def create_link
      yield @callback if block_given?
      
      group = Group.find(@params[:group_id])
      return @callback.on_unauthorized.try(:call) unless @user.groups.include?(group)
      
      link = group.links.where(url: link_params[:url]).first
      if link.present?
        link.update_attributes(posted: false)
        return @callback.on_already_exist.try(:call, link)
      end
      
      link = group.links.build(link_params)
      link.posted_by = @user.id
      if link.save
        @callback.on_created.try(:call, link)
      else
        @callback.on_invalid.try(:call, link)
      end
    end
    
    protected
    def link_params
      @params.require(:link).permit(:title, :url)
    end
  end

  class Callback
    attr_accessor :on_created, :on_invalid, :on_unauthorized, :on_already_exist
    
    def created(&block)
      @on_created = block
    end
    
    def invalid(&block)
      @on_invalid = block
    end
    
    def unauthorized(&block)
      @on_unauthorized = block
    end
    
    def already_exist(&block)
      @on_already_exist = block
    end
    
  end
end