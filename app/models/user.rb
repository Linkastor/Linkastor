class User < ActiveRecord::Base
  include ActiveModel::Validations
  
  has_many :authentication_providers, dependent: :destroy
  has_and_belongs_to_many :groups
  has_many :invites, :foreign_key => "referrer_id"
  
  validates :email, uniqueness: true
  validates_with EmailValidator, :on => :update  
end