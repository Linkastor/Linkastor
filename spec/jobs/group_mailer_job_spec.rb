require "rails_helper"

describe GroupMailerJob do
  
  before(:each) do
    @user = FactoryGirl.create(:user_with_group)
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
    
    it "marks sent links as posted" do
      link = FactoryGirl.create(:link, group: @group, posted: false)
      GroupMailerJob.new.send
      link.reload.posted.should == true
    end
  end
end