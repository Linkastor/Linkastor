require "rails_helper"

describe SessionsController do
  
  let(:user) { FactoryGirl.create(:user) }
  
  describe "POST create" do
    before(:each) do
      Oauth::Authorization.any_instance.stubs(:authorize).returns(user)
    end
    
    it "redirects to user edit path" do
      get :create, provider: "twitter"
      response.should redirect_to edit_user_path(user)
    end
  end
end

