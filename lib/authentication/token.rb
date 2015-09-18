module Authentication
  class Token
    def initialize(user:)
      @user = user
    end
    
    def create
      token = SecureRandom.hex
      auth_key = Authentication::Token.key(token: token)
      $redis.set(auth_key, user.id)
      $redis.expire(auth_key, Rails.application.config.api_session_expiration)
      token
    end
    
    def self.user(token:)
      return if token.nil?
      
      user_id = $redis.get(self.key(token: token))
      User.find(user_id) if user_id.present?
    end
    
    private
      attr_reader :user
    
      def self.key(token:)
        "authentication_"+token
      end
  end

end