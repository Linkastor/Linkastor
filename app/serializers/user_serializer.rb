class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :avatar, :auth_token
  
  def auth_token
    serialization_options[:token]
  end
end
