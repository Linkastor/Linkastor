require 'clockwork'
module Clockwork
  handler do |job|
    puts "Running job #{job}"

    GroupMailerJob.perform_async if job=="send_mail.job"
    CustomSourcesJob.perform_async if job=="import_sources.job"
  end

  every(1.day, 'send_mail.job', :at => '04:00')
  every(1.day, 'import_sources.job', :at => '22:00')
end