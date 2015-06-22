class Group < ActiveRecord::Base
  attr_accessor :emails
  
  has_many :groups_users
  has_many :users, through: :groups_users, dependent: :destroy
  has_many :invites
  has_many :links, dependent: :destroy
  
  validates :name, presence: true
  
  def links_to_post
    links.not_posted
  end
end