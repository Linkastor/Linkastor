class DigestMailerPreview < ActionMailer::Preview
  def send_digest
    DigestMailer.send_digest(user: User.last)
  end
end