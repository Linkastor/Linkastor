require "rails_helper"

describe Link do
  describe "create" do
    it { FactoryGirl.build(:link).save.should == true }
    
    context "mandatory fields" do
      it { FactoryGirl.build(:link, url: nil).save.should == false }
      it { FactoryGirl.build(:link, title: nil).save.should == false }
    end
    
    context "duplicate links url" do
      it "creates only one link if links are on the same day" do
        group = FactoryGirl.create(:group)
        FactoryGirl.build(:link, group: group, url: "http://foo.com/bar.html").save.should == true
        FactoryGirl.build(:link, group: group, url: "http://foo.com/bar.html").save.should == false
      end
      
      it "creates two links if links are on different day" do
        group = FactoryGirl.create(:group)
        FactoryGirl.build(:link, group: group, url: "http://foo.com/bar.html", created_at: 1.day.ago).save.should == true
        FactoryGirl.build(:link, group: group, url: "http://foo.com/bar.html").save.should == true
      end
      
      it "creates two links if links are on the same day for different groups" do
        group1 = FactoryGirl.create(:group)
        group2 = FactoryGirl.create(:group)
        FactoryGirl.build(:link, group: group1, url: "http://foo.com/bar.html").save.should == true
        FactoryGirl.build(:link, group: group2, url: "http://foo.com/bar.html").save.should == true
      end
    end
  end
  
  describe "relations" do
    it "belongs to a group" do
      group = FactoryGirl.create(:group)
      links = FactoryGirl.create_list(:link, 2, group: group)
      group.reload.links.should == links
    end
  end
end