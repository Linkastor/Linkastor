class Link < ActiveRecord::Base
  belongs_to :group
  validates :url, :title, presence: true
  
  validate :unique_url_per_group_per_day
  
  def unique_url_per_group_per_day
    if group.links.where("url = ? AND created_at >= ?", url, Date.today.beginning_of_day).count > 0
      errors.add(:url, "this link was already posted to this group today")
    end
  end
end