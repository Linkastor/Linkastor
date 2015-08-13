module CustomSources::FeedParser
  class AtomItem
    attr_reader :item

    def initialize(item:)
      @item = item
    end

    def published
      item.published.to_s
    end

    def link
      Nokogiri::HTML(item.link.to_s).search("link").first["href"]
    end

    def title
      Nokogiri::HTML(item.title.to_s).search("title").first.content
    end
  end
end