module ThirdParties::Pocket
  class Connection
    def initialize(user:)
      @user = user
      @callback = Callback.new
    end

    def connected?
      yield @callback if block_given?
      auth_provider = @user.authentication_providers.where(provider: "pocket").first

      if auth_provider.nil?
        @callback.on_not_connected.try(:call)
      else
        @callback.on_connected.try(:call, auth_provider.uid)
      end
    end

    def disconnect!
      @user.authentication_providers.where(provider: "pocket").destroy_all
    end

  end

  class Callback
    attr_accessor :on_connected, :on_not_connected
    
    def connected(&block)
      @on_connected = block
    end
    
    def not_connected(&block)
      @on_not_connected = block
    end
  end

end