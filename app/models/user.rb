class User < ActiveRecord::Base
  include ActiveModel::Validations
  
  has_many :authentication_providers
  has_and_belongs_to_many :groups
  has_many :invites, :foreign_key => "referrer"
  
  validates :email, uniqueness: true
  validates_with EmailValidator, :on => :update  
end