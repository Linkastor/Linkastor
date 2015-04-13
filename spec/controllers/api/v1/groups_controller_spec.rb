require "rails_helper"

describe Api::V1::GroupsController do
  render_views
  
  let(:user) { FactoryGirl.create(:user) }
  
  describe 'GET index' do
    context "user not signed in" do
      it "returns 401" do
        get :index
        response.status.should == 401
      end
    end
    
    context "user signed in" do
      before(:each) do
        sign_in(user)
      end
      
      context "user has groups" do
        it "returns user group list" do
          group1 = FactoryGirl.create(:group, users: [user], name: "group 1")
          group2 = FactoryGirl.create(:group, users: [user], name: "group 2")
          
          get :index, auth_token: @token
          
          result = JSON.parse(response.body)
          result["groups"][0]["id"].should == group1.id
          result["groups"][0]["name"].should == "group 1"
          result["groups"][1]["id"].should == group2.id
          result["groups"][1]["name"].should == "group 2"
        end
        
        it "returns user single group" do
          group = FactoryGirl.create(:group, users: [user], name: "group 1")
          
          get :index, auth_token: @token
          
          result = JSON.parse(response.body)
          result["groups"][0]["id"].should == group.id
          result["groups"][0]["name"].should == "group 1"
        end
      end
      
      context "user has no groups" do
        it "retruns empty result" do
          get :index, auth_token: @token
          
          result = JSON.parse(response.body)
          result["groups"].should == []
        end
      end
    end
  end
end