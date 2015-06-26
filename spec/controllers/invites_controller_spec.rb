require "rails_helper"

describe InvitesController do
  render_views

  let(:user) { FactoryGirl.create(:user) }  
  let(:group) { FactoryGirl.create(:group) }
  let(:invite) { FactoryGirl.create(:invite) }
  
  describe "GET show" do
    context "valid invitation code" do
      it "assigns invite" do
        get :show, id: invite.code
        assigns(:invite).should == invite
      end
      
      it "saves invite id in session" do
        get :show, id: invite.code
        session[:invite_id].should == invite.id
      end
    end
    
    context "invitation code doesn't exist" do
      it "raises record not found (404)" do
        expect {
          get :show, id: "foo"
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
  
  describe "POST create" do
    context "user not logged in" do
      it "redirects to root url" do
        post :create, group_id: group.to_param, emails: "foo@bar.com"
        response.should redirect_to root_url
      end
    end
    
    context "user logged in" do
      before(:each) do
        session[:user_id] = user.id
      end
      
      context "valid invite" do
        it "redirects to group list" do
          post :create, group_id: group.to_param, emails: "foo@bar.com"
          response.should redirect_to group_url(group)
        end
      end
      
      context "invalid invite" do
        it "redirects to group list with invalid emails" do
          post :create, group_id: group.to_param, emails: "foobar"
          response.should redirect_to group_url(group)
          assigns(:invalid_emails).should
        end
      end
    end
  end
  
  describe "resend" do
    context "user not logged in" do
      it "redirects to root url" do
        post :resend, invite_id: invite.to_param
        response.should redirect_to root_url
      end
    end
    
    context "user logged in" do
      before(:each) do
        session[:user_id] = user.id
      end
      
      it "sends invite again" do
        Invitation::Request.any_instance.expects(:send_emails).with(invites: [invite])
        post :resend, invite_id: invite.to_param
      end
    end
  end
end