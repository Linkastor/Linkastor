module TwitterClient
  class LinksExtractor
    def initialize
      @client = TwitterClient::Api.new
    end
    
    def extract(username:, since:)
      tweets = @client.tweets(username: username, since: since)
      tweets.map do |tweet|
        url = tweet.text.extract_url
        TwitterClient::TweetStatus.new(tweet.full_text, tweet.full_text.extract_url) if url
      end.compact
    end
  end
end