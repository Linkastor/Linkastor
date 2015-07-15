class ThirdParties::PocketController < ApplicationController
  before_action :authenticate_current_user!, only: [:destroy, :add_link]

  def authorize
    ThirdParties::Pocket::Client.new(user: current_user).authorize!(request_token: session[:pocket_request_token])
    session.delete(:pocket_request_token)
    flash[:info] = "You have successfully connected your pocket account"
    redirect_to third_parties_path
  end

  def destroy
    ThirdParties::Pocket::Connection.new(user: current_user).disconnect!
    redirect_to third_parties_path
  end

  def add_link
    auth_provider = current_user.authentication_providers.where(provider: "pocket").first
    link = params[:link]
    ThirdParties::Pocket::Client.new(user: current_user).add_link(title: link[:title], url: link[:url], access_token: auth_provider.token)
    flash[:info] = "Your link has been successfully added to your pocket account"
  end

end