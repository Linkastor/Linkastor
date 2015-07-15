desc "Send daily mail"
task "send" => :environment do
  GroupMailerJob.perform_async
end