FactoryGirl.define do
  factory :user do
    sequence(:email)  {|n| "string#{n}@example.com" }
    name              "string"
    avatar            "string"
    
    factory :user_with_group do
      after(:create) do |user|
        GroupsUser.create(user: user, group: FactoryGirl.create(:group))
      end
    end
  end
end