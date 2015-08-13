require "rails_helper"

describe CustomSources::Rss, vcr: true do

  describe "save" do
    it "cannot save duplicate url" do
      rss = FactoryGirl.build(:rss)
      rss.extra = {url: "http://foo.bar"}
      rss.save.should == true

      rss = FactoryGirl.build(:rss)
      rss.extra = {url: "http://foo.bar"}
      rss.save.should == false
    end

    it "updates existing source" do
      rss = FactoryGirl.create(:rss)
      rss.name = "something else"
      rss.save.should == true
    end
  end

  describe "import" do
    before(:each) do
      Date.stubs(:yesterday).returns(Date.parse("2015-06-25"))
    end

    it "reads product hunt feed" do
      rss = FactoryGirl.create(:rss)
      rss.extra["url"] = "http://www.producthunt.com/feed"
      rss.import
      rss.links.count.should == 45
    end
    
    it "saves url and content" do
      rss = FactoryGirl.create(:rss)
      rss.extra["url"] = "http://www.producthunt.com/feed"
      rss.import
      link = rss.links.first
      link.url.should == "http://www.producthunt.com/r/4570ddb30433f0/25610?app_id=339"
      link.title.should == "Antbassador — You're a human finger in a world of ants"
    end

    context "RSS format instead of atom" do
      it "saves url and content" do
        rss = FactoryGirl.create(:rss)
        rss.extra["url"] = "https://remoteworking.curated.co/issues.rss"
        rss.import
        link = rss.links.first
        link.url.should == "https://remoteworking.curated.co/issues/38"
        link.title.should == "The Power of Checklists - Aug 10th 2015"
      end
    end
  end
end