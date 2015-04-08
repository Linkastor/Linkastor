FactoryGirl.define do
  factory :invite do
    referrer { FactoryGirl.create(:user).id }
    referee  { FactoryGirl.create(:user).id }
    code              "string"
    accepted          false
  end
end