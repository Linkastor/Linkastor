class Group < ActiveRecord::Base
  attr_accessor :emails
  
  has_and_belongs_to_many :users
  has_many :invites
  
  validates :name, presence: true
end