class Invite < ActiveRecord::Base
  belongs_to :referrer, :class_name => :User, :foreign_key => "referrer_id"
  belongs_to :group
  delegate :name, to: :referrer, prefix: true
  delegate :name, to: :group, prefix: true
  
  validates :referrer, :group, :code, presence: true
  validates :email, uniqueness: {scope: :referrer}
  validates :accepted, :inclusion => {:in => [true, false]}
  validates_with EmailValidator
end