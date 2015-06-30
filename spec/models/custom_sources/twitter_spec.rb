require "rails_helper"

describe CustomSources::Twitter do
  describe "save" do
    it "cannot save without username" do
      twitter = FactoryGirl.build(:twitter)
      twitter.extra = {username: nil}
      twitter.save.should == false
    end

    it "cannot save duplicate username" do
      twitter = FactoryGirl.build(:twitter)
      twitter.extra = {username: "vdaubry"}
      twitter.save.should == true

      twitter2 = FactoryGirl.build(:twitter)
      twitter2.extra = {username: "vdaubry"}
      twitter2.save.should == false
    end
  end
  
  describe "update_from_params" do
    it "creates a twitter source from params" do
      twitter = CustomSources::Twitter.new
      twitter.update_from_params(params: {username: "foo"}).should == true
      twitter.extra["username"].should == "foo"
    end
  end

  describe "relations" do
    it "has many links" do
      links = [FactoryGirl.create(:link)]
      twitter = FactoryGirl.create(:twitter, links: links)
      twitter.links.should == links
    end
  end
  
  describe "import", vcr: true do
    it "creates links from twitter" do
      Date.stubs(:yesterday).returns(Date.parse("2015-06-24"))
      twitter = FactoryGirl.create(:twitter)
      twitter.extra["username"] = "tiboll"
      twitter.import
      Link.count.should == 1
    end
  end
end