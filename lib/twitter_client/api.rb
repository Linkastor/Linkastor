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
      rate_limit do
        client.user_timeline(username, options)
              .select {|tweet| tweet.created_at > since}
      end
    end

    private
    attr_reader :client

    def rate_limit
      begin
        yield
      rescue Twitter::Error::TooManyRequests => error
        wait_time = error.rate_limit.reset_in.try(:+, 1)
        raise TwitterClient::TooManyRequests.new(wait_time)
      end
    end
  end

  class TooManyRequests < StandardError
    attr_reader :wait_time
    def initialize(wait_time)
      @wait_time = wait_time
    end
  end
end