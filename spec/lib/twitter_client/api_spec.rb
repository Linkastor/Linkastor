require "rails_helper"

describe TwitterClient::Api, :vcr => true do
  describe "tweets" do
    it "returns tweets posted since date including urls" do
      tweets = TwitterClient::Api.new.tweets(username: "vdaubry", since: DateTime.parse("01/06/2015"))
      tweets.count.should == 62
    end
  end
end