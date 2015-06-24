require "rails_helper"

describe TwitterClient::LinksExtractor, :vcr => true do
  describe "extract" do
    it "returns links from latest tweets" do
      tweet_statuses = TwitterClient::LinksExtractor.new.extract(username: "vdaubry", since: DateTime.parse("20/06/2015"))
      tweet_statuses.map(&:link).should == ["http://t.co/V2zYuNsLnz", "http://t.co/fB7N8I2b3w", "http://t.co/8o3B2SBMLR", "http://t.co/1V2EadBoES", "http://t.co/ggQDshLCg6", "http://t.co/dEA0ZcLRVJ", "http://t.co/3HnTUs3wMS", "http://t.co/RvnPpoCHUs", "http://t.co/HjIrNN4L3T"]
    end
  end
end