FactoryGirl.define do
  factory :link do
    group
    url     {|n| "http://string.com/#{n}.html" }
    title   "string"
  end
end