class Group < ActiveRecord::Base
  attr_accessor :emails
  
  has_and_belongs_to_many :users
  has_many :invites
  has_many :links, dependent: :destroy
  
  validates :name, presence: true
  
  def links_to_post
    links.not_posted
  end
end