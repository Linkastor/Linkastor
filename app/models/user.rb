class User < ActiveRecord::Base
  include ActiveModel::Validations
  
  has_many :custom_sources_users
  has_many :custom_sources, through: :custom_sources_users, dependent: :destroy
  has_many :authentication_providers, dependent: :destroy
  has_many :groups_users
  has_many :groups, through: :groups_users, dependent: :destroy
  has_many :invites, :foreign_key => "referrer_id"
  has_many :links, :foreign_key => "posted_by"
  
  validates :email, uniqueness: true
  validates_with EmailValidator, :on => :update
  
  def self.with_links_to_post
    #Ugly : Group and CustomSource are actually the same thing, we should refactor to make group Inherit from CustomSource.
    joins("LEFT JOIN groups_users ON groups_users.user_id = users.id").
    joins("LEFT JOIN groups ON groups.id = groups_users.group_id").
    joins("LEFT JOIN custom_sources_users ON custom_sources_users.user_id = users.id").
    joins("LEFT JOIN custom_sources ON custom_sources.id = custom_sources_users.custom_source_id").
    joins("INNER JOIN links ON (links.group_id = groups_users.group_id OR links.custom_source_id = custom_sources_users.custom_source_id)").
    where({:links => {posted: false}}).distinct
  end
end