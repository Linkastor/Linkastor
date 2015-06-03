require "rails_helper"

describe Authentication::Token do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:token) { Authentication::Token.new(user: user) }
  
  describe "create" do
    it "returns a token" do
      token.create.should be_a(String)
    end
    
    it "sets token and user id in redis" do
      SecureRandom.stubs(:hex).returns("foo")
      token.create
      $redis.get("authentication_foo").should == user.id.to_s
    end
    
    it "sets auto expire on token" do
      SecureRandom.stubs(:hex).returns("foo")
      token.create
      $redis.ttl("authentication_foo").should == 1296000#15 days
    end
  end
  
  describe "user" do
    context "finds user" do
      before(:each) do
        $redis.set("authentication_foo", user.id)
      end
      
      it "returns user" do
        Authentication::Token.user(token: "foo").should == user
      end
    end
    
    context "token not found" do
      it "returns nil" do
        Authentication::Token.user(token: "bar").should == nil
      end
    end
    
    context "nil token" do
      it "returns nil" do
        Authentication::Token.user(token: nil).should == nil
      end
    end
  end
  

end
