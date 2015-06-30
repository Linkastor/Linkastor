require "rails_helper"

describe AuthenticationProvider do
  describe "create" do
    it { FactoryGirl.build(:authentication_provider).save.should == true }
    
    context "mandatory fields" do
      it { FactoryGirl.build(:authentication_provider, user_id: nil).save.should == false }
      it { FactoryGirl.build(:authentication_provider, provider: nil).save.should == false }
      it { FactoryGirl.build(:authentication_provider, uid: nil).save.should == false }
      it { FactoryGirl.build(:authentication_provider, token: nil).save.should == false }
      it { FactoryGirl.build(:authentication_provider, secret: nil).save.should == true  }
    end
    
    context "duplicate fields" do
      it "validates unique uid" do
        FactoryGirl.create(:authentication_provider, uid: "foo")
        FactoryGirl.build(:authentication_provider, uid: "foo").save.should == false
      end
    end
  end
end