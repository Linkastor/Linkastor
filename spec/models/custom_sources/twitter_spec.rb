require "rails_helper"

describe CustomSources::Twitter do
  describe "save" do
    it "cannot save without username" do
      twitter = FactoryGirl.build(:twitter)
      twitter.extra = {username: nil}
      twitter.save.should == false
    end
  end
  
  describe "new_from_params" do
    it "creates a twitter source from params" do
      twitter = CustomSources::Twitter.new_from_params(params: {username: "foo"})
      twitter.save.should == true
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