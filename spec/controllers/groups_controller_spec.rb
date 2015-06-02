require "rails_helper"

describe GroupsController do
  
  let(:user) { FactoryGirl.create(:user) }
  
  describe "GET index" do
    context "user not logged in" do
      it "returns to sign in page" do
        get :index
        response.should redirect_to root_url
      end
    end
    
    it "returns only user groups" do
      session[:user_id] = user.id
      group1 = FactoryGirl.create(:group, users: [user])
      group2 = FactoryGirl.create(:group)
      get :index
      assigns(:groups).should == [group1]
    end
  end
  
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
      
      context "Valid name" do
        it "adds group to user" do
          expect {
            post :create, group: { name: "foo" }
          }.to change { user.groups.count }.by(1)
        end
        
        it "redirects to group list" do
          post :create, group: { name: "foo" }
          response.should redirect_to groups_url
        end
      end
      
      context "invalid name" do
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
      
      context "nil emails" do
        it "are allowed, rendirecting to group list" do
          post :create, group: { name: "foo", emails: nil }
          response.should redirect_to groups_url
        end
      end
      
      context "some invalid emails" do
        it "doesn't send any invite" do
          expect {
            post :create, group: { name: "foo", emails: "foo@bar.com;foo1.com" }
          }.to change { Invite.count }.by(0)
        end
        
        it "renders new" do
          post :create, group: { name: "foo", emails: "foo@bar.com;foo1.com" }
          response.should render_template "edit"
        end
      end
      
      context "valid emails" do
        it "send invites" do
          expect {
            post :create, group: { name: "foo", emails: "foo@bar.com;foo1@bar.com" }
          }.to change { Invite.count }.by(2)
        end
      end
    end
    
    describe "GET edit" do
      context "user not logged in" do
        it "redirects to root url" do
          get :new
          response.should redirect_to root_url
        end
      end
      
      context "user logged in" do
        before(:each) do
          session[:user_id] = user.id
        end
      
        it "edits existing group" do
          group = FactoryGirl.create(:group)
          get :edit, id: group.id
          assigns(:group).should == group
        end
      end
    end
    
    describe "PUT update" do
      let(:group) { FactoryGirl.create(:group) }
      
      context "user not logged in" do
        it "redirects to root url" do
          put :update, id: group.id
          response.should redirect_to root_url
        end
      end
      
      context "user logged in" do
        before(:each) do
          session[:user_id] = user.id
        end
      
        it "update existing group" do
          put :update, id: group.id, group: { name: "new_foo" }
          group.reload.name.should == "new_foo"
        end
        
        context "invalid group name" do
          it "update existing group" do
            put :update, id: group.id, group: { name: nil }
            response.should render_template "edit"
          end
        end
      end
    end
  end
end

