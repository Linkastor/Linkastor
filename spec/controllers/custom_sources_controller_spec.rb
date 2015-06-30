require "rails_helper"

describe CustomSourcesController do
  render_views
  
  let(:user) { FactoryGirl.create(:user) }
  let(:twitter) { FactoryGirl.create(:twitter) }
  let(:rss) { FactoryGirl.create(:rss) }
  
  context "user not logged in" do
    describe "index, new" do
      it "redirects to login page" do
        [:index, :new].each do |action|
          get action, type: 'twitter'
          response.should redirect_to root_url
        end
      end
    end

    describe "edit" do
      it "redirects to login page" do
        [:edit, :update].each do |action|
          get action, id: twitter.to_param, type: 'twitter'
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
    
    describe "GET new" do
      it "assigns a new Twitter source" do
        get :new, type: "twitter"
        assigns(:custom_source).should be_a_new CustomSources::Twitter
      end
    end
    
    describe "POST create" do
      context "valid params" do
        it "adds a twitter custom source to the user" do
          expect {
            post :create, type: "twitter", username: "foobar"
          }.to change{ user.custom_sources.count }.by(1)
        end

        it "adds a rss custom source to the user" do
          expect {
            post :create, type: "rss", url: "http://foo.bar"
          }.to change{ user.custom_sources.count }.by(1)
        end
      end
      
      context "invalid params" do
        it "renders new custom source" do
          post :create, type: "twitter"
          response.should render_template "custom_sources/new"
        end
      end
    end

    describe "GET edit" do
      it "assigns existing custom_source" do
        get :edit, id: twitter.to_param, type: "twitter"
        assigns(:custom_source).should == twitter
      end
    end

    describe "PUT update" do
      context "valid params" do
        it "updates twitter custom source" do
          put :update, id: twitter.to_param, type: "twitter", username: "foobaz"
          twitter.reload.extra["username"].should == "foobaz"
        end

        it "updates rss custom source" do
          put :update, id: rss.to_param, type: "rss", url: "http://foo.bar"
          rss.reload.extra["url"].should == "http://foo.bar"
        end
      end

      context "invalid params" do
        it "updates custom source" do
          put :update, id: twitter.to_param, type: "twitter", username: nil
          twitter.reload.extra["username"].should_not be_nil
          response.should render_template(:edit)
        end
      end
    end
  end
end