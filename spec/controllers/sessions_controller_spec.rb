require "rails_helper"

describe SessionsController do
  
  let(:user) { FactoryGirl.create(:user) }
  
  describe "GET create" do
    before(:each) do
      Oauth::Authorization.any_instance.stubs(:authorize).returns(user)
    end
    
    it "redirects to user edit path" do
      get :create, provider: "twitter"
      response.should redirect_to edit_user_path(user)
    end
  end
  
  describe "GET failure" do
    it "redirects to home page" do
      get :failure
      response.should redirect_to '/'
    end
  end
end

