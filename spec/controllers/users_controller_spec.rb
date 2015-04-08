require "rails_helper"

describe UsersController do 
  render_views
  
  let(:user) { FactoryGirl.create(:user) }
  
  describe "GET edit" do
    it "renders edit template" do
      get :edit, id: user.id
      response.should render_template("edit")
    end
  end
  
  describe "PUT update" do
    it "updates user email" do
      put :update, id: user.id, user: {email: "foo@linkastor.com"}
      user.reload.email.should == "foo@linkastor.com"
    end
    
    context "invalid email" do
      it "doesn't update user email" do
        old_email = user.email
        put :update, id: user.id, user: {email: "foo"}
        user.reload.email.should == old_email
      end
    
      it "renders edit" do
        put :update, id: user.id, user: {email: "foo"}
        response.should render_template("edit")
      end
    end
  end
end