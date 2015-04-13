class AuthenticationProvider < ActiveRecord::Base
  belongs_to :user
  
  validates :user_id, :provider, :uid, :token, :secret, presence: true
  validates :uid, uniqueness: true
end