require "rails_helper"

describe ThirdParties::PocketController do
  let(:user) { FactoryGirl.create(:user) }

  describe "GET authorize" do
    before(:each) do
      session[:pocket_request_token] = "foobar"
    end

    it "authorizes pocket connect" do
      ThirdParties::Pocket::Client.any_instance.expects(:authorize!).with(request_token: "foobar")
      get :authorize
    end

    it "clears token from session" do
      ThirdParties::Pocket::Client.any_instance.stubs(:authorize!).returns(true)
      get :authorize
      session[:pocket_request_token].should == nil
    end

    it "redirects to third parties" do
      ThirdParties::Pocket::Client.any_instance.stubs(:authorize!).returns(true)
      get :authorize
      response.should redirect_to third_parties_path
    end
  end

  describe "DELETE destroy" do
    context "user not logged in" do
      it "returns to sign in page" do
        delete :destroy
        response.should redirect_to root_url
      end
    end

    context "user logged in" do
      before(:each) do
        session[:user_id] = user.id
      end

      it "cancels pocket connect" do
        ThirdParties::Pocket::Connection  .any_instance.expects(:disconnect!)
        delete :destroy
      end

      it "redirects to third parties" do
        delete :destroy
        response.should redirect_to third_parties_path
      end
    end
  end

  describe "GET add_link" do
    context "user not logged in" do
      it "returns to sign in page" do
        get :add_link, link: {title: "foo", url: "http://foo.bar"}
        response.should redirect_to root_url
      end
    end

    context "user logged in" do
      before(:each) do
        session[:user_id] = user.id
        FactoryGirl.create(:authentication_provider, provider: "pocket", user: user, token: "foobar")
      end

      it "adds link to pocket" do
        ThirdParties::Pocket::Client.any_instance.expects(:add_link).with(title: "foo", url: "http://foo.bar", access_token: "foobar")
        post :add_link, link: {title: "foo", url: "http://foo.bar"}
      end
    end
  end
end