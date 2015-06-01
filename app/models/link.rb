class Link < ActiveRecord::Base
  belongs_to :group
  belongs_to :user, :foreign_key => "posted_by"
  
  scope :not_posted, -> { where(posted: false) }
  
  validates :posted_by, :group, :url, :title, presence: true
  validate :unique_url_per_group_per_day
  
  def unique_url_per_group_per_day
    if group && group.links.where("url = ? AND created_at >= ?", url, Date.today.beginning_of_day).count > 0
      errors.add(:url, "this link was already posted to this group today")
    end
  end
end