unless Rails.env.test?
  clock = Clock.new(crontab: "* 7 * * *")
  clock.on_alarm = Proc.new { GroupMailerJob.new.send }
  clock.async.tick
end