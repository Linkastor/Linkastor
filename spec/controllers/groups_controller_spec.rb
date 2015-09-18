require "rails_helper"

describe GroupsController do
  render_views

  let(:user) { FactoryGirl.create(:user) }
  let(:group) { FactoryGirl.create(:group) }

  describe "GET show" do
    context "user not logged in" do
      it "returns to sign in page" do
        get :show, id: group.id
        response.should redirect_to root_url
      end
    end

    context "user logged in" do
      before(:each) do
        session[:user_id] = user.id
      end

      it "groups links by days" do
        day1 = Date.parse("10/10/2010")
        day2 = Date.parse("11/10/2010")
        day3 = Date.parse("11/10/2009")

        link1 = FactoryGirl.create(:link, group: group, created_at: day1)
        link2 = FactoryGirl.create(:link, group: group, created_at: day1)
        link3 = FactoryGirl.create(:link, group: group, created_at: day2)
        link4 = FactoryGirl.create(:link, group: group, created_at: day3)

        get :show, id: group.id
        assigns(:links_by_day).should == {day3 => [link4],
                                          day1 => [link1, link2],
                                          day2 => [link3]}
      end


    end
  end
  
  describe "GET index" do
    context "user not logged in" do
      it "returns to sign in page" do
        get :index
        response.should redirect_to root_url
      end
    end
    
    it "returns only user groups" do
      session[:user_id] = user.id
      group1 = FactoryGirl.create(:group)
      group2 = FactoryGirl.create(:group)
      GroupsUser.create(group: group1, user: user)
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
          get :edit, id: group.id
          assigns(:group).should == group
        end
      end
    end
    
    describe "PUT update" do
      
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

