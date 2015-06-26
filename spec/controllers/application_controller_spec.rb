require "rails_helper"

describe ApplicationController do
render_views

  let(:user) { FactoryGirl.create(:user) }
  
  describe "home" do
    it "returns 200 status" do
      get :home
      response.code.should == "200"
    end
    
    it "redirects to groups if user logged in" do
      session[:user_id] = user.id
      get :home
      response.should redirect_to groups_url
    end
    
    it "renders home if user not logged in" do
      get :home
      response.should render_template 'home'
    end
  end
  
  describe "current_user" do
    context "user logged in" do
      it "returns user from session" do
        session[:user_id] = user.id
        
        controller.instance_eval{ current_user }.should == user
      end
    end
    
    context "user not logged in" do
      it "returns nil" do
        session[:user_id] = nil
        controller.instance_eval{ current_user }.should == nil
      end
    end
    
    context "user doesn't exist" do
      it "resets user session" do
        session[:user_id] = 666
        controller.instance_eval{ current_user }.should == nil
      end
    end
  end
end