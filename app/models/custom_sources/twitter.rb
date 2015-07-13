module CustomSources
  class Twitter < CustomSource
    validate :check_user_name
    
    def check_user_name
      self.errors.add(:base, "Missing twitter username") if self.extra["username"].blank?

      duplicate_username = CustomSource.where("extra ->> 'username'='#{self.extra["username"]}'")
      if self.persisted?        
        duplicate_username = duplicate_username.where("id != #{self.id}")
      end
      self.errors.add(:base, "Twitter username already taken") if duplicate_username.present?
    end
    
    def update_from_params(params:)
      self.update(name: "twitter", extra: {username: params[:username]})
    end

    def display_name
      self.extra["username"]
    end
    
    def logo
      "twitterlogo.png"
    end

    def avatar
      "https://twitter.com/#{self.extra["username"]}/profile_image?size=normal"
    end

    def import
      tweet_statuses = TwitterClient::LinksExtractor.new.extract(username: self.extra["username"], 
                                                                  since: Date.yesterday.beginning_of_day)
      tweet_statuses.each do |status|
        self.links.create(url: status.link, title: status.text)
      end
    end
  end
end
