require "rails_helper"

describe FetchMetaJob, vcr: true do
  describe "perform" do
    it "should fetch meta" do
      link = FactoryGirl.create(:link, url: 'http://techcrunch.com/2015/06/25/githubs-atom-text-editor-hits-1-0-now-has-over-350000-monthly-active-users/')

      FetchMetaJob.new.perform(link.id)

      link.reload
      link.description.should == 'GitHub\'s highly extensible Atom text editor hit 1.0 today. The editor release has only been available to the public for about a year now, but it has already..'
      link.image_url.should == 'https://tctechcrunch2011.files.wordpress.com/2015/06/pasted-image-0.png?w=560&h=292&crop=1'
    end

    it "doesn't override meta" do
      link = FactoryGirl.create(:link,
                                url: 'http://techcrunch.com/2015/06/25/githubs-atom-text-editor-hits-1-0-now-has-over-350000-monthly-active-users/',
                                description: 'this is my description',
                                image_url: 'http://www.google.com/logo.png')

      FetchMetaJob.new.perform(link.id)

      link.reload
      link.description.should == 'this is my description'
      link.image_url.should == 'http://www.google.com/logo.png'
    end

    it "counts number of words" do
      link = FactoryGirl.create(:link, url: 'http://techcrunch.com/2015/06/25/githubs-atom-text-editor-hits-1-0-now-has-over-350000-monthly-active-users/')

      FetchMetaJob.new.perform(link.id)

      link.reload.wordcount.should == 838
    end

    it "force encoding when counting words" do
      link = FactoryGirl.create(:link, url: "http://steveblank.com/2013/07/22/an-mvp-is-not-a-cheaper-product-its-about-smart-learning/")

      FetchMetaJob.new.perform(link.id)

      link.reload.wordcount.should == 5477
    end

    it "doesn't fetch meta for pdf" do
      link = FactoryGirl.create(:link, url: 'http://martinfowler.com/ieeeSoftware/whenType.pdf')

      FetchMetaJob.new.perform(link.id)

      link.reload
      link.description.should == nil
    end

  end
end