Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_OAUTH_API_ID'], ENV['TWITTER_OAUTH_API_SECRET']
end