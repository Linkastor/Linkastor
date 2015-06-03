FactoryGirl.define do
  factory :link do
    group
    sequence(:url)  {|n| "http://string.com/#{n}.html" }
    title           "string"
    posted          false
    posted_by       { FactoryGirl.create(:user).id }
  end
end