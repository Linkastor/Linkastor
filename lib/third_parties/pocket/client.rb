class ThirdParties::Pocket::Client
  
  def post(path:, body:)
    uri = URI.parse("https://getpocket.com")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(path)
    request.add_field('Content-Type', 'application/json')
    request.add_field('X-Accept', 'application/json')
    request.body = body.to_json
    response = http.request(request)
    JSON.parse(response.body)
  end

  def token
    json_resp = post(path: "/v3/oauth/request", body: {consumer_key: ENV["POCKET_CONSUMER_KEY"], redirect_uri: Rails.application.routes.url_helpers.authorize_pocket_url})
    json_resp["code"]
  end

  def authorize!(user:, request_token:)
    json_resp = post(path: "/v3/oauth/authorize", body: {consumer_key: ENV["POCKET_CONSUMER_KEY"], code: request_token})
    ThirdParties::Pocket::AuthorizationResponse.new(user: user, auth_resp: json_resp).parse_and_save!
  end

end