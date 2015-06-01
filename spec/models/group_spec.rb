require "rails_helper"

describe Group do
  
  let(:group) { FactoryGirl.create(:group) }
  
  describe "create" do
    it { FactoryGirl.build(:group).save.should == true }
    
    context "mandatory fields" do
      it { FactoryGirl.build(:group, name: nil).save.should == false }
    end
  end
  
  describe "user association" do
    it "has many users" do
      users = FactoryGirl.create_list(:user, 2)
      
      group.users << users
      group.save
      
      Group.last.users.should == users
    end
    
    it "destroy all links" do
      FactoryGirl.create(:link, group: group)
      
      expect {
        group.destroy
      }.to change { Link.count }.by(-1)
    end
  end
  
  describe "links_to_post" do
    it "returns group links not yet posted" do
      link1 = FactoryGirl.create(:link, group: group, posted: false)
      link2 = FactoryGirl.create(:link, group: group, posted: true)
      link3 = FactoryGirl.create(:link, posted: false)
      
      group.links_to_post.should == [link1]
    end
  end
end