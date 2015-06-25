require "rails_helper"

describe CustomSourcesController do
  render_views
  
  let(:user) { FactoryGirl.create(:user) }
  let(:twitter) { FactoryGirl.create(:twitter) }
  
  let(:valid_attributes) { FactoryGirl.build(:twitter).attributes }
  
  context "user not logged in" do
    describe "index" do
      it "redirects to login page" do
        [:index, :new].each do |action|
          get action, type: 'twitter'
          response.should redirect_to root_url
        end
      end
    end
  end
  
  context "user logged in" do
    before(:each) do
      session[:user_id] = user.id
    end
    
    describe "index" do
      it "assigns empty user custom source" do
        get :index
        assigns(:custom_sources).should == []
      end
      
      it "assigns user custom source" do
        CustomSourcesUser.create(user: FactoryGirl.create(:user), custom_source: FactoryGirl.create(:twitter))
        CustomSourcesUser.create(user: user, custom_source: twitter)
        get :index
        assigns(:custom_sources).should == [twitter]
      end
    end
    
    describe "new" do
      it "assigns a new Twitter source" do
        get :new, type: "twitter"
        assigns(:custom_source).should be_a_new CustomSources::Twitter
      end
    end
    
    describe "create" do
      context "valid params" do
        it "adds a custom source to the user" do
          expect {
            post :create, type: "twitter", username: "foobar"
          }.to change{ user.custom_sources.count }.by(1)
        end
      end
      
      context "invalid params" do
        it "renders new custom source" do
          post :create, type: "twitter"
          response.should render_template "custom_sources/twitter/new"
        end
      end
    end
  end
end