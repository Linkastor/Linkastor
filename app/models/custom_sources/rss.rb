require 'rss'
require 'open-uri'

module CustomSources
  class Rss < CustomSource
    validate :check_url
    
    def check_url
      self.errors.add(:base, "Missing url") if self.extra["url"].blank?
      self.errors.add(:base, "Url already taken") if CustomSource.where("extra ->> 'url'='#{self.extra["url"]}'").present?
    end
    
    def self.new_from_params(params:)
      self.new(name: "rss", extra: {url: params[:url], website_logo: params[:website_logo], website_name: params[:website_name]})
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
        items = feed.items.select do |item| 
          DateTime.parse(item.published.to_s) > DateTime.yesterday.beginning_of_day
        end   
        items.each do |item|
          link = Nokogiri::HTML(item.link.to_s).search("link").first["href"]
          title = Nokogiri::HTML(item.title.to_s).search("title").first.content
          self.links.create(url: link, title: title)
        end
      end
    end
  end
end
