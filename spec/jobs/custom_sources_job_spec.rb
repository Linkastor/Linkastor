require "rails_helper"

describe CustomSourcesJob do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:twitter) { FactoryGirl.create(:twitter) }

  describe "#perform" do
    it "calls import custom sources" do
      CustomSources::Twitter.any_instance.expects(:import).once
      CustomSourcesJob.new.perform(twitter.id)
    end
  end
end