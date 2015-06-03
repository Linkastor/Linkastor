class ApplicationMailer < ActionMailer::Base
  default from: "noreply@linkastor.herokuapp.com"
  layout 'mailer'
end
