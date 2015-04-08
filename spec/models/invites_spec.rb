require "rails_helper"

describe Invite do
  describe "create" do
    it { FactoryGirl.build(:invite).save.should == true }
    
    context "mandatory fields" do
      it { FactoryGirl.build(:invite, referrer: nil).save.should == false }
      it { FactoryGirl.build(:invite, referee: nil).save.should == false }
      it { FactoryGirl.build(:invite, code: nil).save.should == false }
      it { FactoryGirl.build(:invite, accepted: nil).save.should == false }
    end
  end
  
  describe "association" do
    it "has a referrer" do
      invite = FactoryGirl.build(:invite, referrer: nil)
      user = FactoryGirl.create(:user)
      
      invite.referrer = user.id
      invite.save
      
      Invite.last.referrer.should == user.id
    end
    
    it "has a referee" do
      invite = FactoryGirl.build(:invite, referee: nil)
      user = FactoryGirl.create(:user)
      
      invite.referee = user.id
      invite.save
      
      Invite.last.referee.should == user.id
    end
  end
end