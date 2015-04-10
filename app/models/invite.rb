class Invite < ActiveRecord::Base
  #TODO : add delegation pour group name, referrer name, etc, see : http://apidock.com/rails/Module/delegate
  belongs_to :referrer, :class_name => :User, :foreign_key => "referrer_id"
  belongs_to :group
  
  validates :referrer, :code, presence: true
  validates :email, uniqueness: {scope: :referrer}
  validates :accepted, :inclusion => {:in => [true, false]}
  validates_with EmailValidator
end