require "rails_helper"

describe CustomSources::Rss, vcr: true do

  let(:rss) { FactoryGirl.create(:rss) }

  describe "save" do
    it "cannot save duplicate url" do
      rss.extra = {url: "http://foo.bar"}
      rss.save.should == true

      rss = FactoryGirl.build(:rss)
      rss.extra = {url: "http://foo.bar"}
      rss.save.should == false
    end

    it "updates existing source" do
      rss.name = "something else"
      rss.save.should == true
    end
  end

  describe "relations" do
    it "destroys associated CustomSourcesUser" do
      user = FactoryGirl.create(:user)
      twitter = FactoryGirl.create(:twitter)
      CustomSourcesUser.create(user: user, custom_source: twitter)
      twitter.destroy
      CustomSourcesUser.count.should == 0
    end
  end

  describe "import" do
    before(:each) do
      Date.stubs(:yesterday).returns(Date.parse("2015-06-25"))
    end

    it "reads product hunt feed" do
      rss.extra["url"] = "http://www.producthunt.com/feed"
      rss.import
      rss.links.count.should == 45
    end
    
    it "saves url and content" do
      rss.extra["url"] = "http://www.producthunt.com/feed"
      rss.import
      link = rss.links.first
      link.url.should == "http://www.producthunt.com/r/4570ddb30433f0/25610?app_id=339"
      link.title.should == "Antbassador — You're a human finger in a world of ants"
    end

    context "RSS format instead of atom" do
      it "saves url and content" do
        rss.extra["url"] = "https://remoteworking.curated.co/issues.rss"
        rss.import
        link = rss.links.first
        link.url.should == "https://remoteworking.curated.co/issues/38"
        link.title.should == "The Power of Checklists - Aug 10th 2015"
      end
    end

    context "RSS feed has some invalid value" do
      it "raises an InvalidRss error" do
        rss.extra["url"] = "http://www.producthunt.com/feed"
        RSS::Parser.stubs(:parse).raises(RSS::NotAvailableValueError.new("foo", "bar"))
        expect {
          rss.import
        }.to raise_error(CustomSources::InvalidRss)
      end
    end

    context "RSS feed has some invalid date" do
      it "skips link" do
        rss.extra["url"] = "http://www.producthunt.com/feed"
        DateTime.stubs(:parse).raises(ArgumentError)
        rss.import
        rss.links.count.should == 0
      end
    end
  end
end