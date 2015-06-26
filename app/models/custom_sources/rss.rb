require 'rss'
require 'open-uri'

module CustomSources
  class Rss < CustomSource
    validate :check_url
    
    def check_url
      self.errors.add(:base, "Missing url") if self.extra["url"].blank?
    end
    
    def self.new_from_params(params:)
      self.new(name: "rss", extra: {url: params[:url]})
    end

    def display_name
      self.extra["url"]
    end
    
    def logo
      "rsslogo.png"
    end

    def import
      open(self.extra["url"]) do |rss|
        feed = RSS::Parser.parse(rss)
        items = feed.items.select { |item| DateTime.parse(item.published.to_s) > DateTime.yesterday.beginning_of_day }
        items.each do |item|
          # content = ActionController::Base.helpers.strip_tags(CGI.unescapeHTML(item.content.to_s))
          # ["\n", "“", "”"].each { |el| content.gsub!(el, ""))
          # strip_content = content.strip
          link = Nokogiri::HTML(item.link.to_s).search("link").first["href"]
          self.links.create(url: link, title: item.content)
        end
      end
    end
  end
end
