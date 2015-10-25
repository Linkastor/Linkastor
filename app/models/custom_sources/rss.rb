require 'rss'
require 'open-uri'

module CustomSources
  class InvalidRss < StandardError; end

  class Rss < CustomSource
    validate :check_url

    def self.find_or_initialize(params:)
      CustomSources::Rss.where('extra @> ?', {"url"=>params[:url]}.to_json).first_or_initialize
    end
    
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

    def feed(rss)
      RSS::Parser.parse(rss, false)
    rescue StandardError => e
      Rails.logger.error "cannot parse #{display_name} : #{e}"
      raise CustomSources::InvalidRss.new(e.message)
    end

    def import
      today_items = all_items.map {|feed_item| CustomSources::FeedParser::ItemFactory.new(item: feed_item).item}
                  .select {|item| published_after_yesterday?(item) }
      today_items.each do |item|
        link = self.links.build(url: item.link, title: item.title)
        if link.save
          FetchMetaJob.perform_async(link.id)
        end
      end
    end

    def all_items
      open(self.extra["url"]) do |rss|
        feed(rss).items
      end
    end

    def published_after_yesterday?(item)
      begin
        DateTime.parse(item.published) > DateTime.yesterday.beginning_of_day
      rescue ArgumentError => e
        Rails.logger.error("Found invalid date : #{item.published} in feed #{self.extra["url"]}")
        false
      end
    end
  end
end
