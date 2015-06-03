require "rails_helper"

describe Link do
  
  let(:group) { FactoryGirl.create(:group) }
  
  describe "create" do
    it { FactoryGirl.build(:link).save.should == true }
    
    context "mandatory fields" do
      it { FactoryGirl.build(:link, url: nil).save.should == false }
      it { FactoryGirl.build(:link, title: nil).save.should == false }
      it { FactoryGirl.build(:link, group_id: nil).save.should == false }
      it { FactoryGirl.build(:link, posted_by: nil).save.should == false }
    end
    
    context "duplicate links url" do
      it "creates only one link for the same group" do
        FactoryGirl.build(:link, group: group, url: "http://foo.com/bar.html").save.should == true
        FactoryGirl.build(:link, group: group, url: "http://foo.com/bar.html").save.should == false
      end
      
      it "creates two links if links are on different groups" do
        group2 = FactoryGirl.create(:group)
        FactoryGirl.build(:link, group: group, url: "http://foo.com/bar.html").save.should == true
        FactoryGirl.build(:link, group: group2, url: "http://foo.com/bar.html").save.should == true
      end
    end
  end
  
  describe "relations" do
    it "belongs to a group" do
      links = FactoryGirl.create_list(:link, 2, group: group)
      group.reload.links.should == links
    end
    
    it "belongs to a user" do
      user = FactoryGirl.create(:user_with_group)
      links = FactoryGirl.create_list(:link, 2, group: user.groups.first, posted_by: user.id)
      user.reload.links.should == links
    end
  end
  
  describe "not posted" do
    it "returns links not already posted" do 
      link1 = FactoryGirl.create(:link, posted: false)
      link2 = FactoryGirl.create(:link, posted: true)
      Link.not_posted.should == [link1]
    end   
  end
end