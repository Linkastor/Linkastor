require "rails_helper"

describe GroupMailerJob do

  let(:twitter) { FactoryGirl.create(:twitter) }
  
  before(:each) do
    @user = FactoryGirl.create(:user_with_group, admin: true)
    @group = @user.groups.first
  end
  
  describe "perform" do
    it "send a mail to users with links marked as not posted" do
      FactoryGirl.create(:link, group: @group, posted: false)
      DigestMailer.expects(:send_digest).with(user: @user).returns(stub(deliver_now: nil))
      GroupMailerJob.new.perform
    end
    
    it "doesn't send a mail to users with all links marked as posted" do
      FactoryGirl.create(:link, group: @group, posted: true)
      DigestMailer.expects(:send_digest).with(user: @user).never
      GroupMailerJob.new.perform
    end
    
    it "imports all sources" do
      CustomSourcesUser.create(user: @user, custom_source: twitter)
      FactoryGirl.create(:link, custom_source: twitter)
      CustomSources::Twitter.any_instance.expects(:import).once
      GroupMailerJob.new.perform
    end
    
    it "marks sent links as posted" do
      link = FactoryGirl.create(:link, group: @group, posted: false)
      GroupMailerJob.new.perform
      link.reload.posted.should == true
    end
    
    it "sets links posted_at" do
      link = FactoryGirl.create(:link, group: @group, posted: false)
      GroupMailerJob.new.perform
      link.reload.posted_at.should_not be_nil
    end

    context "fail to send email to a user" do
      it "keeps sending mail to next users" do
        user2 = FactoryGirl.create(:user, admin: false)
        user2.groups << @group
        FactoryGirl.create(:link, group: @group, posted: false)
        CustomSourcesUser.create(user: @user, custom_source: twitter)
        CustomSources::Twitter.any_instance.stubs(:import).raises(StandardError)
        DigestMailer.expects(:send_digest).once
        GroupMailerJob.new.perform
      end
    end
  end
end