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
    
    context "user was invited" do
      before(:each) do
        session[:invite_id] = FactoryGirl.create(:invite, 
                                                  email: "invite@foo.com", 
                                                  group: FactoryGirl.create(:group, name: "group bar")
                                                ).id
      end
      
      it "saves invitation email to user email" do
        get :create, provider: "twitter"
        
        User.where(email: "invite@foo.com").count.should == 1
      end
      
      it "add invitation group to user groups" do
        get :create, provider: "twitter"
        
        User.where(email: "invite@foo.com").first.groups.map(&:name).should == ["group bar"]
      end
      
      it "redirects to groups path" do
        get :create, provider: "twitter"
        response.should redirect_to groups_path
      end
    end
  end
  
  describe "GET failure" do
    it "redirects to home page" do
      get :failure
      response.should redirect_to '/'
    end
  end
end

