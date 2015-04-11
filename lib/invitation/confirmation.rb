module Invitation
  class Confirmation
    def initialize(invite:, referee:)
      @invite = invite
      @referee = referee
    end
    
    def accept!
      @referee.email = @invite.email
      @referee.groups << @invite.group
      @referee.save
    end
  end
end