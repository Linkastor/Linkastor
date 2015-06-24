module TwitterClient
  class LinksExtractor
    def initialize
      @client = TwitterClient::Api.new
    end
    
    def extract(username:, since:)
      tweets = @client.tweets(username: username, since: since)
      tweets.map {|tweet| TwitterClient::TweetStatus.new(tweet.text, tweet.text.extract_url )}.compact
    end
  end
end