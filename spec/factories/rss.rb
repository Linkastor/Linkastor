FactoryGirl.define do
  sequence(:url) {|n| "http://foo.bar/feed#{n}" }

  factory :rss, :class => CustomSources::Rss do |t|
    t.name "Rss"
    
    after(:build) do |twitter|
      twitter.extra = {url: generate(:url)}
    end
  end
end