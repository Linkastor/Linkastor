require "rails_helper"

describe Api::V1::LinksController do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:group) { FactoryGirl.create(:group, users: [user]) }
  
  describe "POST create" do
    context "user not signed in" do
      it "returns 401" do
        post :create, group_id: group.id
        response.status.should == 401
      end
    end
    
    context "user signed in" do
      before(:each) do
        sign_in(user)
      end
      
      context "valid link params" do
        it "add the link to group" do
          post :create, auth_token: @token, group_id: group.id, link: { title: "foo bar", url: "http://foo.com/bar.html" }
          link = group.reload.links.first
          link.title.should == "foo bar"
          link.url.should == "http://foo.com/bar.html"
        end
        
        it "returns 201" do
          post :create, auth_token: @token, group_id: group.id, link: { title: "foo bar", url: "http://foo.com/bar.html" }
          response.status.should == 201
        end
        
        it "returns the created link" do
          post :create, auth_token: @token, group_id: group.id, link: { title: "foo bar", url: "http://foo.com/bar.html" }
          result = JSON.parse(response.body)
          result["link"]["title"].should == "foo bar"
          result["link"]["url"].should == "http://foo.com/bar.html"
        end
      end
      
      context "group doesn't exist" do
        it "raises ActiveRecord not found (404)" do
          expect {
            post :create, auth_token: @token, group_id: 123, link: { title: "foo bar", url: "http://foo.com/bar.html" }
            }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
      
      context "group exists but belongs to another user" do
        it "returns 403 forbidden" do
          other_group = FactoryGirl.create(:group)
          post :create, auth_token: @token, group_id: other_group.id, link: { title: "foo bar", url: "http://foo.com/bar.html" }
          response.status.should == 403
        end
      end
      
      context "invalid link params" do
        it "returns 422 Unprocessable entity" do
          post :create, auth_token: @token, group_id: group.id, link: { title: nil, url: nil }
          response.status.should == 422
        end
        
        it "returns validation errors" do
          post :create, auth_token: @token, group_id: group.id, link: { title: nil, url: nil }
          result = JSON.parse(response.body)
          result["error"].should == ["Url can't be blank", "Title can't be blank"]
        end
      end
      
      context "post same link url multiple times on the same date" do
        it "creates only one link" do
          post :create, auth_token: @token, group_id: group.id, link: { title: "foo bar", url: "http://foo.com/bar.html" }
          post :create, auth_token: @token, group_id: group.id, link: { title: "foo bar", url: "http://foo.com/bar.html" }
          Link.count.should == 1
        end
      end
      
      context "post same link url on different group" do
        it "creates 2 links" do
          group2 = FactoryGirl.create(:group, users: [user])
          post :create, auth_token: @token, group_id: group.id, link: { title: "foo bar", url: "http://foo.com/bar.html" }
          post :create, auth_token: @token, group_id: group2.id, link: { title: "foo bar", url: "http://foo.com/bar.html" }
          Link.count.should == 2
        end
      end
      
    end
  end
end