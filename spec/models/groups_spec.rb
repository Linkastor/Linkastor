require "rails_helper"

describe Group do
  describe "create" do
    it { FactoryGirl.build(:group).save.should == true }
    
    context "mandatory fields" do
      it { FactoryGirl.build(:group, name: nil).save.should == false }
    end
  end
  
  describe "user association" do
    it "has many users" do
      users = FactoryGirl.create_list(:user, 2)
      group = FactoryGirl.create(:group)
      
      group.users << users
      group.save
      
      Group.last.users.should == users
    end
  end
end