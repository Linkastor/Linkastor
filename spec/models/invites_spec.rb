require "rails_helper"

describe Invite do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:group) { FactoryGirl.create(:group) }
  
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
        FactoryGirl.build(:invite, referrer: user, email: "foo@bar.com").save.should == true
        FactoryGirl.build(:invite, referrer: user, email: "foo@bar.com").save.should == false
      end
    end
  end
  
  describe "association" do
    it "has a referrer" do
      FactoryGirl.create(:invite, referrer: user)
      Invite.last.referrer.should == user
    end
    
    it "has a group" do
      FactoryGirl.create(:invite, group: group)
      
      Invite.last.group.should == group
    end
  end
  
  describe "delegation" do
    it "delegates referrer_name" do
      invite = FactoryGirl.create(:invite, referrer: user)
      invite.referrer_name.should == user.name
    end
    
    it "delegates group name" do
      invite = FactoryGirl.create(:invite, group: group)
      invite.group_name.should == group.name
    end
  end
end