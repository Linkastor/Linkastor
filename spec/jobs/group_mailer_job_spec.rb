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

    it "doesn't update posted_at for links already posted" do
      link = FactoryGirl.create(:link, group: @group, posted: false, posted_at: nil)
      link2 = FactoryGirl.create(:link, group: @group, posted: true, posted_at: Date.parse("2015-08-11"))
      GroupMailerJob.new.perform
      link.reload.posted_at.should_not be_nil
      link2.reload.posted_at.should == Date.parse("2015-08-11")
    end
  end
end