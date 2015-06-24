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
      
    end
  end
end
