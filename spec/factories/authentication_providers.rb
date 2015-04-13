FactoryGirl.define do
  factory :authentication_provider do
    user
    sequence(:uid)      {|n| "uid#{n}"}
    provider            "string"
    token               "string"
    secret              "string"
  end
end