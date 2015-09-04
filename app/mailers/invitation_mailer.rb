class InvitationMailer < ApplicationMailer
  def send_invite(invite)
    @invite = invite
    @referrer = invite.referrer
    @group = invite.group
    @join_url = invite_url(invite.code)
    mail(to: @invite.email, subject: "#{@referrer.name} invites you to join #{@group.name} on Linkastor", skip_premailer: INLINE_MAIL_CSS)
  end
end
