class DigestMailer < ApplicationMailer
  def send_digest(user:)
    @user = user
    @groups = user.groups
    @custom_sources = @user.admin ? user.custom_sources : []
    mail(to: @user.email, subject: "Yummy ! Your Linkastor daily digest")
  end
end
