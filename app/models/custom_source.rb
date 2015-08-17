class CustomSource < ActiveRecord::Base
  has_many :links, dependent: :destroy
  has_many :custom_sources_users
  has_many :users, through: :custom_sources_users

  #FIXME: Dirty hack to force a cascade delete on custom_sources_users. We should find a cleaner way to delete join models...
  before_destroy do |custom_source|
    ActiveRecord::Base.connection.execute("DELETE from custom_sources_users WHERE custom_source_id=#{custom_source.id}")
  end

  validates :type, :extra, presence: true

  def links_to_post
    links.not_posted
  end
end