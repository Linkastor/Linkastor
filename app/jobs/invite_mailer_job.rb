class InviteMailerJob
  include Sidekiq::Worker

  def perform(invite)
    return if invite.referrer.nil?
    InvitationMailer.send_invite(invite).deliver_now
  end
end