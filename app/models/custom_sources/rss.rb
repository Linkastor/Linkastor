require 'rss'
require 'open-uri'

module CustomSources
  class Rss < CustomSource
    validate :check_url
    
    def check_url
      self.errors.add(:base, "Missing url") if self.extra["url"].blank?

      duplicate_url = CustomSource.where("extra ->> 'url'='#{self.extra["url"]}'")
      if self.persisted?        
        duplicate_url = duplicate_url.where("id != #{self.id}")
      end
      self.errors.add(:base, "Url already taken") if duplicate_url.present?
    end
    
    def update_from_params(params:)
      self.update(name: "rss", extra: {url: params[:url], website_logo: params[:website_logo], website_name: params[:website_name]})
    end
    
    def display_name
      self.extra["website_name"]
    end
    
    def logo
      "rsslogo.png"
    end

    def avatar
      self.extra["website_logo"]
    end

    def import
      open(self.extra["url"]) do |rss|
        feed = RSS::Parser.parse(rss)
        items = feed.items
                    .map {|feed_item| CustomSources::FeedParser::ItemFactory.new(item: feed_item).item}
                    .select {|item| DateTime.parse(item.published) > DateTime.yesterday.beginning_of_day }
        items.each do |item|
          link = item.link
          title = item.title
          self.links.create(url: link, title: title)
        end
      end
    end
  end
end
