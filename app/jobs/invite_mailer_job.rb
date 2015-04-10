class InviteMailerJob
  include SuckerPunch::Job

  def perform(invite)
    return if invite.referrer.nil?
    ActiveRecord::Base.connection_pool.with_connection do
      InvitationMailer.send_invite(invite).deliver_now
    end
  end
end