desc "Send daily mail"
task "send" => :environment do
  GroupMailerJob.new.perform
end