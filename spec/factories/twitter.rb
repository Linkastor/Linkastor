FactoryGirl.define do
  factory :twitter, :class => CustomSources::Twitter do |t|
    t.name "Twitter"
    
    after(:build) do |twitter|
      twitter.extra = {:username => "foobar"}
    end
  end
end