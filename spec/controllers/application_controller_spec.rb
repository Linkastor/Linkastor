require "rails_helper"

describe ApplicationController do
render_views
  
  describe "home" do
    it "returns 200 status" do
      get :home
      response.code.should == "200"
    end
  end
end