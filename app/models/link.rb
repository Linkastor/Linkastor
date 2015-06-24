class Link < ActiveRecord::Base
  belongs_to :group
  belongs_to :custom_source
  belongs_to :user, :foreign_key => "posted_by"
  
  scope :not_posted, -> { where(posted: false) }
  
  validates :posted_by, :group, :url, :title, presence: true
  validates :url, uniqueness: { scope: :group_id }

  self.per_page = 10
end