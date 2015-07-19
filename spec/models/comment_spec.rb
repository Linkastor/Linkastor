require 'rails_helper'

describe Comment do
  let(:group) { FactoryGirl.create(:group) }
  let(:user) { FactoryGirl.create(:user) }
  let(:link) { FactoryGirl.build(:link, url: 'http://foo.com/bar.html', group: group, posted_by: user).save }

  describe "create" do
    it { FactoryGirl.build(:comment).save.should == true }

    context "mandtory fields" do
      it { FactoryGirl.build(:comment, content: nil).save.should == false }
      it { FactoryGirl.build(:comment, user_id: nil).save.should == false }
      it { FactoryGirl.build(:comment, link_id: nil).save.should == false }
    end
  end
end
