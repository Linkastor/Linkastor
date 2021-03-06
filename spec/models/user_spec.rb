require "rails_helper"

describe User do
  
  let(:user) { FactoryGirl.create(:user) }
  
  describe "create" do
    it { FactoryGirl.build(:user).save.should == true }

    it "can create multiple user without email" do
      FactoryGirl.build(:user, email: nil).save.should == true
      FactoryGirl.build(:user, email: nil).save.should == true
    end
    
    context "duplicate fields" do
      it "validates unique emails" do
        FactoryGirl.create(:user, :email => "foo@bar.com")
        FactoryGirl.build(:user, :email => "foo@bar.com").save.should == false
      end
    end
    
    context "relations" do
      it "has many authentication providers" do
        FactoryGirl.create(:authentication_provider, user: user, provider: "facebook")
        FactoryGirl.create(:authentication_provider, user: user, provider: "twitter")
        user.reload.authentication_providers.count.should == 2
      end
      
      it "has many links" do
        user = FactoryGirl.create(:user_with_group)
        FactoryGirl.create_list(:link, 2, group: user.groups.first, posted: false, posted_by: user.id)
        user.links.count.should == 2
      end
    end
    
    it "allow nil email only at create time" do
      FactoryGirl.create(:user, email: nil).should be_truthy
    end
    
    it "destroys authentication providers when destroyed" do
      FactoryGirl.create(:authentication_provider, user: user)
      expect {
        user.destroy
      }.to change { AuthenticationProvider.count }.by(-1)
    end
  end
  
  describe "update" do
    it { user.update_attributes(email: nil).should == false }
    it { user.update_attributes(email: "foo").should == false }
    it { user.update_attributes(email: "foo@bar.com").should == true }
  end
  
  describe "with_links_to_post" do
    it "returns user with at least one link not posted in a group" do
      user = FactoryGirl.create(:user_with_group)
      FactoryGirl.create(:link, group: user.groups.first, posted: false, posted_by: user.id)
      User.with_links_to_post.should == [user]
    end
    
    it "returns empty if all links are posted" do
      User.with_links_to_post.should == []
    end
    
    it "returns user with at least one link not posted in a custom source" do
      user = FactoryGirl.create(:user)
      twitter = FactoryGirl.create(:twitter)
      CustomSourcesUser.create(user: user, custom_source: twitter)
      FactoryGirl.create(:link, custom_source: twitter, posted: false)
      User.with_links_to_post.should == [user]
    end

    it "returns distinct users" do
      user = FactoryGirl.create(:user_with_group)
      FactoryGirl.create_list(:link, 2, group: user.groups.first, posted: false, posted_by: user.id)
      User.with_links_to_post.should == [user]
    end
  end
  
  describe "associations" do
    it "cannot have the same group twice" do
      group = FactoryGirl.create(:group)
      user = FactoryGirl.create(:user)
      GroupsUser.create(user: user, group: group)
      GroupsUser.create(user: user, group: group)
      user.groups.should == [group]
    end
    
    it "destroys associated groups_user" do
      user = FactoryGirl.create(:user_with_group)
      GroupsUser.count.should == 1
      user.destroy
      GroupsUser.count.should == 0
    end

    it "has a twitter custom source" do
      twitter = FactoryGirl.create(:twitter)
      CustomSourcesUser.create(user: user, custom_source: twitter)
      user.custom_sources.should == [twitter]
    end
    
    it "cannot have duplicate custom sources" do
      twitter = FactoryGirl.create(:twitter)
      CustomSourcesUser.create(user: user, custom_source: twitter)
      CustomSourcesUser.create(user: user, custom_source: twitter)
      user.custom_sources.should == [twitter]
    end

    it "destroys associated CustomSourcesUser" do
      twitter = FactoryGirl.create(:twitter)
      CustomSourcesUser.create(user: user, custom_source: twitter)
      user.destroy
      CustomSourcesUser.count.should == 0
    end
  end
end