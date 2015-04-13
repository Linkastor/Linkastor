class Oauth::Authorization
  def authorize(oauth_hash:)
    #We identify the user by its twitter id
    authentication_provider = AuthenticationProvider.where(:uid => oauth_hash["uid"]).first
    
    #For new users we build an authentication provider
    if authentication_provider.nil?
      user = User.new
      update_user(user: user, oauth_hash: oauth_hash)
      authentication_provider = user.authentication_providers.build
    else
    #For existing user we just update their info
      user = authentication_provider.user
      update_user(user: user, oauth_hash: oauth_hash)
    end
    
    #In every case we update the oauth token
    update_authentication_provider(authentication_provider: authentication_provider, oauth_hash: oauth_hash)
    
    return user
  end
  
  def update_user(user:, oauth_hash:)
    user.name = oauth_hash.extra.raw_info.name
    user.avatar = oauth_hash.extra.raw_info.profile_image_url
    user.save
  end
  
  def update_authentication_provider(authentication_provider:, oauth_hash:)
    authentication_provider.uid = oauth_hash.uid
    authentication_provider.token = oauth_hash.credentials.token
    authentication_provider.secret = oauth_hash.credentials.secret
    authentication_provider.provider = oauth_hash.provider
    authentication_provider.save
  end
end