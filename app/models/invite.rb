class Invite < ActiveRecord::Base
  belongs_to :user, :foreign_key => "referrer"
  belongs_to :group
  
  validates :referrer, :code, presence: true
  validates :email, uniqueness: {scope: :referrer}
  validates :accepted, :inclusion => {:in => [true, false]}
  validates_with EmailValidator
end