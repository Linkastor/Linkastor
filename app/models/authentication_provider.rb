class AuthenticationProvider < ActiveRecord::Base
  belongs_to :user
  
  validates :user_id, :provider, :uid, :token, presence: true
  validates :uid, uniqueness: true
  validates :provider, uniqueness: {scope: :user_id}
end