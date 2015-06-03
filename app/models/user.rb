class User < ActiveRecord::Base
  include ActiveModel::Validations
  
  has_many :authentication_providers, dependent: :destroy
  has_and_belongs_to_many :groups
  has_many :invites, :foreign_key => "referrer_id"
  has_many :links, :foreign_key => "posted_by"
  
  scope :with_links_to_post, -> { joins(:groups => :links).where({:links => {posted: false}}) }
  
  validates :email, uniqueness: true
  validates_with EmailValidator, :on => :update  
end