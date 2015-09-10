class CustomSourcesJob
  include Sidekiq::Worker

  def perform
    User.joins(:custom_sources_users).find_each do |user|
      begin
        user.custom_sources.map(&:import)
      rescue StandardError => e
        Rails.logger.error e
        Raven.capture_exception(e)
      end
    end
  end
end