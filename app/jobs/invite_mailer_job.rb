class InviteMailerJob
  include Sidekiq::Worker

  def perform(invite_id)
    invite = Invite.find(invite_id)
    InvitationMailer.send_invite(invite).deliver_now
  end
end