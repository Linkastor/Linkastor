require "rails_helper"

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/cassette_library'
  c.hook_into :webmock
  c.default_cassette_options = { :record => :new_episodes }
  c.configure_rspec_metadata!
end

describe Twitter::ApiClient, :vcr => true do
  describe "tweets" do
    it "returns tweets posted since date" do
      tweets = Twitter::ApiClient.new.tweets(username: "vdaubry", since: "22/06/2015")
      tweets.count.should == 4
    end
  end
end