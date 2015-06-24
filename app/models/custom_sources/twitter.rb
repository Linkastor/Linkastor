module CustomSources
  class Twitter < CustomSource
    validate :check_user_name
    
    def check_user_name
      self.errors.add(:base, "Missing twitter username") if self.extra["username"].blank?
    end
    
    def self.new_from_params(params:)
      self.new(name: "twitter", extra: {username: params[:username]})
    end

    def display_name
      "Twitter #{self.extra["username"]}"
    end

    def import
      tweet_statuses = TwitterClient::LinksExtractor.new.extract(username: self.extra["username"], since: Date.yesterday.beginning_of_day)
      tweet_statuses.each do |status|
        self.links.create(url: status.link, title: status.text)
      end
    end
  end
end
