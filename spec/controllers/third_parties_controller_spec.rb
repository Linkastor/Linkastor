require 'rails_helper'

describe ThirdPartiesController do
  render_views
  let(:user) { FactoryGirl.create(:user) }

  describe "GET index" do
    context "user not logged in" do
      it "returns to sign in page" do
        get :index
        response.should redirect_to root_url
      end
    end

    context "user logged in" do
      before(:each) do
        session[:user_id] = user.id
      end

      context "connected to pocket" do
        before(:each) do
          FactoryGirl.create(:authentication_provider, uid: "foobar", provider: "pocket", user: user)
        end

        it "assigns pocket username" do
          get :index
          assigns(:pocket_username).should == "foobar"
        end
      end

      context "not connected to pocket", vcr: true do
        it "assigns pocket oauth request url" do
          get :index
          assigns(:pocket_auth_url).should == "https://getpocket.com/auth/authorize?request_token=6f19ecb5-6706-e5dc-78e1-5f6c98&redirect_uri=http://test.host/pocket/authorize"
        end

        it "sets pocket request token in user session" do
          get :index
          session[:pocket_request_token].should == "ff6334cf-eaef-d09f-e0de-e28cb9"
        end
      end
    end
  end
end