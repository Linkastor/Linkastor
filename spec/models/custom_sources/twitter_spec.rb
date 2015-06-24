require "rails_helper"

describe CustomSources::Twitter do
  describe "save" do
    it "cannot save without username" do
      twitter = FactoryGirl.build(:twitter)
      twitter.extra = {username: nil}
      twitter.save.should == false
    end
  end
  
  describe "new_from_params" do
    it "creates a twitter source from params" do
      twitter = CustomSources::Twitter.new_from_params(params: {username: "foo"})
      twitter.save.should == true
      twitter.extra["username"].should == "foo"
    end
  end
  
  
end