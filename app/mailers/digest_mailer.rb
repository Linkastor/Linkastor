class DigestMailer < ApplicationMailer
  def send_digest(user:)
    @user = user
    @groups = user.groups
    mail(to: @user.email, subject: "Yummy ! Your Linkastor daily digest")
  end
end
