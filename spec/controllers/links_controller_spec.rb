require "rails_helper"

describe LinksController do
  render_views

  let(:group) { FactoryGirl.create(:group) }
  let(:link) { FactoryGirl.create(:link, group: group) }

  describe "GET show" do
    context "not logged in" do
      it "renders 401" do
        get :show, group_id: group.to_param, id: link.to_param
        response.code.should == "301"
      end
    end

    context "user logged in" do
      before(:each) do
        session[:user_id] = FactoryGirl.create(:user).id
      end

      it "renders show template" do
        get :show, group_id: group.to_param, id: link.to_param
        assigns(:group).should == group
      end
    end
  end
end