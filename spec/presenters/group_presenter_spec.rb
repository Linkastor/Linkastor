require "rails_helper"

describe GroupPresenter do
  let(:group) { FactoryGirl.create(:group) }

  context "no link to post" do
    it "hasLinkToPost should return false" do
      GroupPresenter.hasLinkToPost(group).should == false
    end
  end

  context "has link to post" do
    it "hasLinkToPost should return true" do
      day = DateTime.now

      link = FactoryGirl.create(:link, group: group, created_at: day)

      GroupPresenter.hasLinkToPost(group).should == true
    end
  end
end