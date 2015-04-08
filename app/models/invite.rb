class Invite < ActiveRecord::Base
  belongs_to :user, :foreign_key => "referrer"
  belongs_to :user, :foreign_key => "referee"
  
  validates :referrer, :referee, :code, presence: true
  validates :referrer, uniqueness: {scope: :referee}
  validates :accepted, :inclusion => {:in => [true, false]}
end