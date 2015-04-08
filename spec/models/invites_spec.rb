require "rails_helper"

describe Invite do
  describe "create" do
    it { FactoryGirl.build(:invite).save.should == true }
    
    context "mandatory fields" do
      it { FactoryGirl.build(:invite, referrer: nil).save.should == false }
      it { FactoryGirl.build(:invite, email: nil).save.should == false }
      it { FactoryGirl.build(:invite, code: nil).save.should == false }
      it { FactoryGirl.build(:invite, accepted: nil).save.should == false }
    end
    
    context "duplicate email for same referrer" do
      it "doesn't create invite" do
        User.destroy_all
        user = FactoryGirl.create(:user)
        FactoryGirl.build(:invite, referrer: user.id, email: "foo@bar.com").save.should == true
        FactoryGirl.build(:invite, referrer: user.id, email: "foo@bar.com").save.should == false
      end
    end
  end
  
  describe "association" do
    it "has a referrer" do
      user = FactoryGirl.create(:user)
      invite = FactoryGirl.create(:invite, referrer: user.id)
      
      Invite.last.referrer.should == user.id
    end
    
    it "has a group" do
      group = FactoryGirl.create(:group)
      invite = FactoryGirl.create(:invite, group: group)
      
      Invite.last.group.should == group
    end
  end
end