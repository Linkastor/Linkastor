class User < ActiveRecord::Base
  include ActiveModel::Validations
  
  has_many :custom_sources_users
  has_many :custom_sources, through: :custom_sources_users, dependent: :destroy
  has_many :authentication_providers, dependent: :destroy
  has_many :groups_users
  has_many :groups, through: :groups_users, dependent: :destroy
  has_many :invites, :foreign_key => "referrer_id"
  has_many :links, :foreign_key => "posted_by"
  
  scope :with_links_to_post, -> { joins(:groups => :links).where({:links => {posted: false}}) }
  
  validates :email, uniqueness: true
  validates_with EmailValidator, :on => :update
end