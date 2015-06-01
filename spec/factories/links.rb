FactoryGirl.define do
  factory :link do
    group
    sequence(:url)  {|n| "http://string.com/#{n}.html" }
    title           "string"
    posted          false
  end
end