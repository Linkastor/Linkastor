FactoryGirl.define do
  factory :rss, :class => CustomSources::Rss do |t|
    t.name "Rss"
    
    after(:build) do |twitter|
      twitter.extra = {url: "http://foo.bar/feed"}
    end
  end
end