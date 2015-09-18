class Link < ActiveRecord::Base
  belongs_to :group
  belongs_to :custom_source
  belongs_to :user, :foreign_key => "posted_by"
  
  scope :not_posted, -> { where(posted: false) }
  scope :recent, -> { order(created_at: :desc) }
  
  validates :url, :title, presence: true
  validates :posted_by, presence:true, if: 'group_id.present?'
  validates :url, uniqueness: { scope: :group_id }, if: 'group_id.present?'
  validates :url, uniqueness: { scope: :custom_source_id }, if: 'custom_source_id.present?'

  self.per_page = 10
end