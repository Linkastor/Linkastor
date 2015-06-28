require "rails_helper"

describe GroupMailerJob do
  
  before(:each) do
    @user = FactoryGirl.create(:user_with_group, admin: true)
    @group = @user.groups.first
  end
  
  describe "send" do
    it "send a mail to users with links marked as not posted" do
      FactoryGirl.create(:link, group: @group, posted: false)
      DigestMailer.expects(:send_digest).with(user: @user).returns(stub(deliver_now: nil))
      GroupMailerJob.new.send
    end
    
    it "doesn't send a mail to users with all links marked as posted" do
      FactoryGirl.create(:link, group: @group, posted: true)
      DigestMailer.expects(:send_digest).with(user: @user).never
      GroupMailerJob.new.send
    end
    
    it "imports all sources" do
      twitter = FactoryGirl.create(:twitter)
      CustomSourcesUser.create(user: @user, custom_source: twitter)
      FactoryGirl.create(:link, custom_source: twitter)
      CustomSources::Twitter.any_instance.expects(:import).once
      GroupMailerJob.new.send
    end
    
    it "marks sent links as posted" do
      link = FactoryGirl.create(:link, group: @group, posted: false)
      GroupMailerJob.new.send
      link.reload.posted.should == true
    end
    
    it "sets links posted_at" do
      link = FactoryGirl.create(:link, group: @group, posted: false)
      GroupMailerJob.new.send
      link.reload.posted_at.should_not be_nil
    end
  end
end