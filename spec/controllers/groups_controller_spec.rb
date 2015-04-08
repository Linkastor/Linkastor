require "rails_helper"

describe GroupsController do

  describe "GET new" do
    it "assigns a new group" do
      get :new
      assigns(:group).should be_a(Group)
    end
  end
  
  describe "POST create" do
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

