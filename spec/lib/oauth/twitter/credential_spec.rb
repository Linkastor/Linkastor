require "rails_helper"

describe Oauth::Twitter::Credential, :vcr => true do
  describe "verify" do
    context "valid credentials" do
      it "returns twitter user id" do
        #Credentials for test account : https://twitter.com/VdaTest
        credential = Oauth::Twitter::Credential.new(token: "3163966989-WQSbTbgWxWLvEO4LqamYc3MClqNDwo8pf8jUWAr", secret: "QDx59KkRgjMhLbaCnymsIpnjLzDH6LH7a77qFBbnZwQ1J")
        credential.verify.should == 3163966989
      end
    end
    
    context "invalid credentials" do
      it "returns nil" do
        credential = Oauth::Twitter::Credential.new(token: "foo", secret: "bar")
        credential.verify.should == nil
      end
    end
  end
end