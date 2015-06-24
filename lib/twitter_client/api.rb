module TwitterClient
  class Api
    def initialize
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV["TWITTER_OAUTH_API_ID"]
        config.consumer_secret     = ENV["TWITTER_OAUTH_API_SECRET"]
      end
    end
    
    def tweets(username:, since:)
      options = {count: 200}
      tweets = @client.user_timeline(username, options)
      tweets.select {|tweet| tweet.created_at > since}
    end
  end
end