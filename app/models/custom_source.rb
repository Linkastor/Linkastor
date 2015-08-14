class CustomSource < ActiveRecord::Base
  has_many :links, dependent: :destroy
  has_many :custom_sources_users, dependent: :destroy
  has_many :users, through: :custom_sources_users
  
  validates :type, :extra, presence: true
  
  def links_to_post
    links.not_posted
  end
end