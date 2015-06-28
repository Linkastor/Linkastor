FactoryGirl.define do
  sequence(:username) {|n| "foobar#{n}" }

  factory :twitter, :class => CustomSources::Twitter do |t|
    t.name "Twitter"
    
    after(:build) do |twitter|
      twitter.extra = {username: generate(:username)}
    end
  end
end