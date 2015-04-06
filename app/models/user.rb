class User < ActiveRecord::Base
  has_many :authentication_providers
  
  validates :email, uniqueness: true
end