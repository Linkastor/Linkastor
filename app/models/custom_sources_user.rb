class CustomSourcesUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :custom_source
  
  validates :user_id, :custom_source_id, presence: true
  validates :user_id, uniqueness: { scope: :custom_source_id}
end