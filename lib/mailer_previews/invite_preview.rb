class InvitePreview < ActionMailer::Preview
  def invite
    InvitationMailer.send_invite(Invite.last)
  end
end