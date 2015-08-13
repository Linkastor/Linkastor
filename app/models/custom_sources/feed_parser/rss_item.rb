module CustomSources::FeedParser
  class RssItem
    attr_reader :item

    def initialize(item:)
      @item = item
    end

    def published
      item.pubDate.to_s
    end

    def link
      item.link.to_s
    end

    def title
      item.title.to_s
    end
  end
end