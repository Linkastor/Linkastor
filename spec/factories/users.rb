FactoryGirl.define do
  factory :user do
    sequence(:email)  {|n| "string#{n}@example.com" }
    name              "string"
    avatar            "string"
    
    factory :user_with_group do
      after(:create) do |user|
        FactoryGirl.create(:group, users: [user])
      end
    end
  end
end