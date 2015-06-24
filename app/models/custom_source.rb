class CustomSource < ActiveRecord::Base
  has_many :custom_sources_users
  has_many :custom_sources, through: :custom_sources_users, dependent: :destroy
  
  validates :type, :extra, presence: true
end