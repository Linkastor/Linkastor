class ThirdParties::Pocket::AuthorizationResponse
  def initialize(user:, auth_resp:)
    @user = user
    @auth_resp = auth_resp
  end

  def parse_and_save!
    authentication_provider = @user.authentication_providers.build
    authentication_provider.uid = @auth_resp["username"]
    authentication_provider.token = @auth_resp["access_token"]
    authentication_provider.provider = "pocket"
    authentication_provider.save
  end
end