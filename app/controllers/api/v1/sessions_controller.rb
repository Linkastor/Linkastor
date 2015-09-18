class Api::V1::SessionsController < Api::V1::BaseController
  
  def create
    token = params[:auth_token]
    secret = params[:auth_secret]
    if token.blank? || secret.blank?
      return render status: 422, json: {error: "Missing oauth token"}
    end
    
    credential = Oauth::Twitter::Credential.new(token: token, secret: secret)
    twitter_id = credential.verify
    return render status: 401, json: {error: "Bad credentials"} if twitter_id.nil? 
    
    auth_provider = AuthenticationProvider.where(uid: twitter_id).first
    return render status: 401, json: {error: "Your twitter credentials are valid but no corresponding user was found on Linkastor. Please register on our website first"} if auth_provider.nil? 
    
    @user = auth_provider.user
    token = Authentication::Token.new(user: @user).create
    
    render json: @user, token: token
  end
end