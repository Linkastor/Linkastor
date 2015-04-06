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
  end
end