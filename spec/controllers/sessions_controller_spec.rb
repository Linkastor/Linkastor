require "rails_helper"

describe SessionsController do
  describe "POST create" do
    it "creates user" do
      get :create, provider: "twitter"
    end
  end
end

