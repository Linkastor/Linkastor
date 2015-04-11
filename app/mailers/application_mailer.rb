class ApplicationMailer < ActionMailer::Base
  default from: "noreply@linkastor.scalingo.io"
  layout 'mailer'
end
