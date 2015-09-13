require "rails_helper"

describe RemoveDuplicateJob do
  describe "#perform" do
    context "group links" do

      let(:group) { FactoryGirl.create(:group) }

      it "sets link scheduled for delivery within same group with duplicate descriptionn as already posted" do
        link1 = FactoryGirl.create(:link, group: group, description: "foobar desc", posted: false)
        link2 = FactoryGirl.create(:link, group: group, description: "foobar desc", posted: false)
        RemoveDuplicateJob.new.perform(link2.id)
        link1.reload.posted.should == false
        link2.reload.posted.should == true
      end

      it "doesn't change links scheduled for delivery in different groups" do
        group2 = FactoryGirl.create(:group)
        link1 = FactoryGirl.create(:link, group: group, description: "foobar desc", posted: false)
        link2 = FactoryGirl.create(:link, group: group2, description: "foobar desc", posted: false)
        RemoveDuplicateJob.new.perform(link2.id)
        link1.reload.posted.should == false
        link2.reload.posted.should == false
      end

      it "doesn't change links not scheduled for delivery" do
        link1 = FactoryGirl.create(:link, group: group, description: "foobar desc", posted: true)
        link2 = FactoryGirl.create(:link, group: group, description: "foobar desc", posted: false)
        RemoveDuplicateJob.new.perform(link2.id)
        link1.reload.posted.should == true
        link2.reload.posted.should == false
      end

      it "sets link scheduled for delivery within same group with duplicate image as already posted" do
        link1 = FactoryGirl.create(:link, group: group, image_url: "http://www.foo.bar/img.jpg", posted: false)
        link2 = FactoryGirl.create(:link, group: group, image_url: "http://www.foo.bar/img.jpg", posted: false)
        RemoveDuplicateJob.new.perform(link2.id)
        link1.reload.posted.should == false
        link2.reload.posted.should == true
      end

      it "doesn't change links scheduled for delivery in different groups" do
        group2 = FactoryGirl.create(:group)
        link1 = FactoryGirl.create(:link, group: group,  image_url: "http://www.foo.bar/img.jpg", posted: false)
        link2 = FactoryGirl.create(:link, group: group2, image_url: "http://www.foo.bar/img.jpg", posted: false)
        RemoveDuplicateJob.new.perform(link2.id)
        link1.reload.posted.should == false
        link2.reload.posted.should == false
      end

      it "doesn't change links not scheduled for delivery" do
        link1 = FactoryGirl.create(:link, group: group, image_url: "http://www.foo.bar/img.jpg", posted: true)
        link2 = FactoryGirl.create(:link, group: group, image_url: "http://www.foo.bar/img.jpg", posted: false)
        RemoveDuplicateJob.new.perform(link2.id)
        link1.reload.posted.should == true
        link2.reload.posted.should == false
      end
    end

    context "custom source links" do

      let(:twitter) { FactoryGirl.create(:twitter) }

      it "sets link scheduled for delivery within same group with duplicate descriptionn as already posted" do
        link1 = FactoryGirl.create(:link, group: nil, custom_source: twitter, description: "foobar desc", posted: false)
        link2 = FactoryGirl.create(:link, group: nil, custom_source: twitter, description: "foobar desc", posted: false)
        RemoveDuplicateJob.new.perform(link2.id)
        link1.reload.posted.should == false
        link2.reload.posted.should == true
      end

      it "doesn't change links scheduled for delivery in different groups" do
        twitter2 = FactoryGirl.create(:twitter)
        link1 = FactoryGirl.create(:link, group: nil, custom_source: twitter, description: "foobar desc", posted: false)
        link2 = FactoryGirl.create(:link, group: nil, custom_source: twitter2, description: "foobar desc", posted: false)
        RemoveDuplicateJob.new.perform(link2.id)
        link1.reload.posted.should == false
        link2.reload.posted.should == false
      end
    end
  end
end