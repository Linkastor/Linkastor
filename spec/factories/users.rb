FactoryGirl.define do
  factory :user do
    sequence(:email)  {|n| "string#{n}@example.com" }
    name              "string"
    avatar            "string"
  end
end