desc "Send daily mail"
task "import" => :environment do
  CustomSourcesJob.perform_async
end