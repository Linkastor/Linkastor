desc "Send daily mail"
task "import" => :environment do
  CustomSource.find_each do |custom_source|
    CustomSourcesJob.new.perform(custom_source.id)
  end
end