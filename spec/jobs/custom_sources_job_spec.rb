require "rails_helper"

describe CustomSourcesJob do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:twitter) { FactoryGirl.create(:twitter) }

  describe "#perform" do
    before(:each) do
      CustomSourcesUser.create(user: user, custom_source: twitter)
    end

    it "calls import on all user with custom sources" do
      user2 = FactoryGirl.create(:user)
      CustomSourcesUser.create(user: user2, custom_source: twitter)
      CustomSources::Twitter.any_instance.expects(:import).twice
      CustomSourcesJob.new.perform
    end

    it "check only users with custom sources" do
      FactoryGirl.create(:user)
      User.any_instance.expects(:custom_sources).once.returns([])
      CustomSourcesJob.new.perform
    end
  end
end