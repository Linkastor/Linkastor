module CustomSources::FeedParser
  class ItemFactory
    def initialize(item:)
      @item = item
    end

    def item
      if @item.is_a? RSS::Rss::Channel::Item
        CustomSources::FeedParser::RssItem.new(item: @item)
      elsif @item.is_a? RSS::Atom::Feed::Entry
        CustomSources::FeedParser::AtomItem.new(item: @item)
      end
    end
  end
end