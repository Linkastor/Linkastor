require "rails_helper"

describe SessionsController do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:new_user) { FactoryGirl.create(:user, email: nil) } 
  
  describe "GET create" do
    before(:each) do
      Oauth::Authorization.any_instance.stubs(:authorize).returns(user)
    end
    
    context "new user" do
      it "redirects to user edit path" do
        Oauth::Authorization.any_instance.stubs(:authorize).returns(new_user)
        get :create, provider: "twitter"
        response.should redirect_to edit_user_path(new_user)
      end
    end
    
    context "existing user" do
      it "redirects to groups path" do
        get :create, provider: "twitter"
        response.should redirect_to groups_path(user)
      end
    end
    
    it "sets user session" do
      get :create, provider: "twitter"
      session[:user_id].should == User.last.id
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
      
      it "doesn't crash if group doesn't exist anymore" do
        group = FactoryGirl.create(:group, name: "group bar")
        session[:invite_id] = FactoryGirl.create(:invite, 
                                                  email: "invite@foo.com", 
                                                  group: group
                                                ).id
        group.destroy
        get :create, provider: "twitter"
        response.should redirect_to groups_path
      end
      
      it "clear invite in session" do
        get :create, provider: "twitter"
        session[:invite_id].should == nil
      end
    end
    
    context "session_id doesn't exists" do
      it "ignores invite and redirects to groups" do
        session[:invite_id] = 1
        get :create, provider: "twitter"
        response.should redirect_to groups_path(user)
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

