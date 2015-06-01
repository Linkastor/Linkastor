require "rails_helper"

describe User do
  describe "create" do
    it { FactoryGirl.build(:user).save.should == true }
    
    context "duplicate fields" do
      it "validates unique emails" do
        FactoryGirl.create(:user, :email => "foo@bar.com")
        FactoryGirl.build(:user, :email => "foo@bar.com").save.should == false
      end
    end
    
    context "relations" do
      it "has many authentication providers" do
        user = FactoryGirl.create(:user)
        FactoryGirl.create_list(:authentication_provider, 2, user: user)
        user.reload.authentication_providers.count.should == 2
      end
    end
    
    it "allow nil email only at create time" do
      FactoryGirl.create(:user, email: nil).should be_truthy
    end
    
    it "destroys authentication providers when destroyed" do
      user = FactoryGirl.create(:user)
      FactoryGirl.create(:authentication_provider, user: user)
      expect {
        user.destroy
      }.to change { AuthenticationProvider.count }.by(-1)
    end
  end
  
  describe "update" do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end
    
    it { @user.update_attributes(email: nil).should == false }
    it { @user.update_attributes(email: "foo").should == false }
    it { @user.update_attributes(email: "foo@bar.com").should == true }
  end
  
  describe "with_links_to_post" do
    it "returns user with at least one link not posted" do
      user = FactoryGirl.create(:user_with_group)
      FactoryGirl.create(:link, group: user.groups.first, posted: false)
      User.with_links_to_post.should == [user]
    end
    
    it "returns empty if all links are posted" do
      User.with_links_to_post.should == []
    end
  end
end