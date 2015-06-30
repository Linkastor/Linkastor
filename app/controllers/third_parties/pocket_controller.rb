class ThirdParties::PocketController < ApplicationController

  def authorize
    ThirdParties::Pocket::Client.new.authorize!(user: current_user, request_token: session[:pocket_request_token])
    flash[:info] = "You have successfully connected your pocket account"
    redirect_to :third_parties_path
  end

  def destroy
    ThirdParties::Pocket::Connection.new(user: current_user).disconnect!
    session.delete(:pocket_request_token)
    redirect_to :third_parties_path
  end

end