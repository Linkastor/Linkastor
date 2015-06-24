require "rails_helper"

describe Twitter::ApiClient, :vcr => true do
  describe "tweets" do
    it "returns tweets posted since date including urls" do
      tweets = Twitter::ApiClient.new.tweets(username: "vdaubry", since: "01/06/2015")
      tweets.count.should == 58
    end
  end
end