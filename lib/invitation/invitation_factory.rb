module Invitation
  class InvitationFactory
    def initialize(invite_id:)
      @invite_id = invite_id
    end
    
    def invite
      return if @invite_id.nil?
      Invite.where(id: @invite_id).first
    end
  end
end