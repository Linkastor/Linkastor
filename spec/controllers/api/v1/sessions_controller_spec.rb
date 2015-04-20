require "rails_helper"

describe Api::V1::SessionsController do
  render_views
  
  describe "POST create" do
    
    context "valid twitter credentials" do
      context "user exists" do
        before(:each) do
          @user = FactoryGirl.create(:user, 
                                      name: "Mr foo", 
                                      avatar: "http://foo.com/bar.jpg")
          @auth_provider = FactoryGirl.create(:authentication_provider, user: @user)
          Oauth::Twitter::Credential.any_instance.stubs(:verify).returns(@auth_provider.uid)
        end
        
        it "responds 200" do
          post :create, auth_token: @auth_provider.token, auth_secret: @auth_provider.secret
          result = JSON.parse(response.body)
          result["user"]["id"].should == @user.id
          result["user"]["name"].should == "Mr foo"
          result["user"]["avatar"].should == "http://foo.com/bar.jpg"
        end
        
        it "generates a token" do
          post :create, auth_token: @auth_provider.token, auth_secret: @auth_provider.secret
          result = JSON.parse(response.body)
          result["user"]["auth_token"].should be_a(String)
        end
      end
      
      context "user doesn't exists" do
        it "responds with 401 invalid credentials" do
          Oauth::Twitter::Credential.any_instance.stubs(:verify).returns(123)
          post :create, auth_token: "foo", auth_secret: "bar"
          response.status.should == 401
        end
      end
    end
    
    context "invalid twitter credentials" do
      before(:each) do
        Oauth::Twitter::Credential.any_instance.stubs(:verify).returns(nil)
      end
      
      it "responds with 401 invalid credentials" do
         post :create, auth_token: "foo", auth_secret: "bar"
         response.status.should == 401
      end
    end
    
    context "missing token param" do
      it "responds with 422 Unprocessable Entity" do
         post :create, auth_secret: "bar"
         response.status.should == 422
      end
    end
    
    context "missing secret param" do
      it "responds with 422 Unprocessable Entity" do
         post :create, auth_token: "foo"
         response.status.should == 422
      end
    end
  end
  
end