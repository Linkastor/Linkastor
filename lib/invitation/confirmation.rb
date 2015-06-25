module Invitation
  class Confirmation
    def initialize(invite:, referee:)
      @invite = invite
      @referee = referee
      @callback = Callback.new
    end
    
    def accept!
      yield @callback if block_given?
      
      if @invite.group.nil?
        @callback.on_group_invalid.try(:call)
      else
        @referee.email = @invite.email
        @referee.groups << @invite.group
        @referee.save
        @callback.on_success.try(:call, @invite.group)
      end
    end
  end
  
  class Callback
    attr_accessor :on_group_invalid, :on_success
    
    def group_invalid(&block)
      @on_group_invalid = block
    end
    
    def success(&block)
      @on_success = block
    end
  end
end