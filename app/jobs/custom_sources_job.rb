class CustomSourcesJob
  include Sidekiq::Worker

  def perform
    User.joins(:custom_sources).distinct.find_each do |user|
      begin
        user.custom_sources_users.each do |custom_source_user|
          custom_source_user.custom_source.import
        end
      rescue StandardError => e
        Rails.logger.error e
        Raven.capture_exception(e)
      end
    end
  end
end