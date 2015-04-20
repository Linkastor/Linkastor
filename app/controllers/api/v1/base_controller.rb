class Api::V1::BaseController < ActionController::Base
  before_filter :allow_cors
  
  def allow_cors
    headers["Access-Control-Allow-Origin"] = "*"
    headers["Access-Control-Allow-Methods"] = %w{GET POST PUT DELETE}.join(",")
    headers["Access-Control-Allow-Headers"] = %w{Origin Accept Content-Type X-Requested-With X-CSRF-Token X-API-Auth-Token}.join(",")
  end

  def options
    head(:ok)
  end
  
  def authenticate_user!
    render status: 401, json: { message: "Bad credentials" } unless current_user
  end
  
  def current_user
    Authentication::Token.check(token: params[:auth_token])
  end
end