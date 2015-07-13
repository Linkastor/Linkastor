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
      it { FactoryGirl.build(:invite, group: nil).save.should == false }
    end
    
    context "duplicate email for same referrer and same group" do
      it "doesn't create invite" do
        FactoryGirl.build(:invite, group: group, referrer: user, email: "foo@bar.com").save.should == true
        FactoryGirl.build(:invite, group: group, referrer: user, email: "foo@bar.com").save.should == false
      end
    end

    context "duplicate email for same referrer but different group" do
      it "creates invite" do
        FactoryGirl.build(:invite, group: FactoryGirl.create(:group), referrer: user, email: "foo@bar.com").save.should == true
        FactoryGirl.build(:invite, group: FactoryGirl.create(:group), referrer: user, email: "foo@bar.com").save.should == true
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
  
  describe "pending" do
    it "returns not accepted invitations" do
      accepted_invite = FactoryGirl.create(:invite, accepted: true)
      pending_invite = FactoryGirl.create(:invite, accepted: false)
      Invite.pending.should == [pending_invite]
    end
  end
end