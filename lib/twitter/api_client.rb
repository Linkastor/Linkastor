module Twitter
  class ApiClient
    def initialize
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV["TWITTER_OAUTH_API_ID"]
        config.consumer_secret     = ENV["TWITTER_OAUTH_API_SECRET"]
      end
    end
    
    def contains_url?(text:)
      text.match(/((([A-Za-z]{3,9}:(?:\/\/)?)(?:[-;:&=\+\$,\w]+@)?[A-Za-z0-9.-]+|(?:www.|[-;:&=\+\$,\w]+@)[A-Za-z0-9.-]+)((?:\/[\+~%\/.\w-_]*)?\??(?:[-\+=&;%@.\w_]*)#?(?:[\w]*))?)/).present?
    end

    def tweets(username:, since:)
      since = DateTime.parse(since)
      options = {count: 200}
      tweets = @client.user_timeline(username, options)
      tweets.select {|tweet| tweet.created_at > since && contains_url?(text: tweet.text)}
    end
  end
end