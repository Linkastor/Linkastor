module Oauth::Twitter
  class Credential
    def initialize(token:, secret:)
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV["TWITTER_OAUTH_API_ID"]
        config.consumer_secret     = ENV["TWITTER_OAUTH_API_SECRET"]
        config.access_token        = token
        config.access_token_secret = secret
      end
    end

    def verify
      begin
        client.verify_credentials.id
      rescue Twitter::Error::Unauthorized => e
      end
    end

    private
    attr_reader :client
  end
end