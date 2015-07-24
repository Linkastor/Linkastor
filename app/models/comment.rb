class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :link

  validates :content, :user_id, :link_id, presence: true
end
