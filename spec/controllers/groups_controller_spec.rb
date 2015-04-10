require "rails_helper"

describe GroupsController do
  
  let(:user) { FactoryGirl.create(:user) }
  
  describe "GET new" do
    context "user not logged in" do
      it "redirects to root url" do
        get :new
        response.should redirect_to root_url
      end
    end
    
    context "user logged in" do
      it "assigns a new group" do
        session[:user_id] = user.id
        get :new
        assigns(:group).should be_a(Group)
      end
    end
  end
  
  describe "POST create" do
    context "user not logged in" do
      it "returns to sign in page" do
        post :create, group: { name: "foo" }
        response.should redirect_to root_url
      end
    end
    
    context "user logged in" do
      before(:each) do
        session[:user_id] = user.id
      end
      
      context "Valid params" do
        it "creates group" do
          expect {
            post :create, group: { name: "foo" }
          }.to change { Group.count }.by(1)
        end
        
        it "redirects to group list" do
          post :create, group: { name: "foo" }
          response.should redirect_to groups_url
        end
      end
      
      context "invalid params" do
        it "doesn't create group" do
          expect {
            post :create, group: { name: nil }
          }.to change { Group.count }.by(0)
        end
        
        it "renders edit" do
          post :create, group: { name: nil }
          response.should render_template("new")
        end
      end
    end
  end
end

