class ThirdPartiesController < ApplicationController
  before_action :authenticate_current_user!

  def index
    ThirdParties::Pocket::Connection.new(user: current_user).connected? do |on|

      on.connected do |pocket_username|
        @pocket_username = pocket_username
      end

      on.not_connected do
        pocket_request_token = ThirdParties::Pocket::Client.new(user: current_user).token
        @pocket_auth_url = "https://getpocket.com/auth/authorize?request_token=#{pocket_request_token}&redirect_uri=#{authorize_pocket_url}"
        session[:pocket_request_token] = pocket_request_token
      end

    end
  end

end