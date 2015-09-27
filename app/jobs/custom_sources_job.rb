class CustomSourcesJob
  include Sidekiq::Worker

  def perform(custom_source_id)
    CustomSource.find(custom_source_id).import
  end
end