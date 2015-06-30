require "rails_helper"

describe Link do
  
  let(:group) { FactoryGirl.create(:group) }
  let(:twitter) { FactoryGirl.create(:twitter) }
  
  describe "create" do
    it { FactoryGirl.build(:link).save.should == true }
    
    context "mandatory fields" do
      it { FactoryGirl.build(:link, url: nil).save.should == false }
      it { FactoryGirl.build(:link, title: nil).save.should == false }
      it { FactoryGirl.build(:link, posted_by:nil, group: group, custom_source: nil).save.should == false }
      it { FactoryGirl.build(:link, posted_by:nil, group: nil, custom_source: twitter).save.should == true }
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
      
      it "creates only one link for the same source" do
        FactoryGirl.build(:link, custom_source: twitter, url: "http://foo.com/bar.html").save.should == true
        FactoryGirl.build(:link, custom_source: twitter, url: "http://foo.com/bar.html").save.should == false
      end
      
      it "creates two links if links are on different groups" do
        twitter2 = FactoryGirl.create(:twitter)
        FactoryGirl.build(:link, custom_source: twitter, url: "http://foo.com/bar.html").save.should == true
        FactoryGirl.build(:link, custom_source: twitter2, url: "http://foo.com/bar.html").save.should == true
      end
    end
  end

  describe "fetch_meta" do
    it "should fetch meta" do
      VCR.use_cassette("Link/meta/fetch_meta") do
        link = FactoryGirl.build(:link, url: 'http://techcrunch.com/2015/06/25/githubs-atom-text-editor-hits-1-0-now-has-over-350000-monthly-active-users/')

        link.fetch_meta

        link.description.should == 'GitHub\'s highly extensible Atom text editor hit 1.0 today. The editor release has only been available to the public for about a year now, but it has already..'
        link.image_url.should == 'https://tctechcrunch2011.files.wordpress.com/2015/06/pasted-image-0.png?w=560&h=292&crop=1'
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