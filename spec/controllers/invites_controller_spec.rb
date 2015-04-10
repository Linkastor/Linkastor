require "rails_helper"

describe InvitesController do
  render_views
  
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
end