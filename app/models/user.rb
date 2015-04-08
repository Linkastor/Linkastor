class User < ActiveRecord::Base
  has_many :authentication_providers
  has_and_belongs_to_many :groups
  has_many :invites, :foreign_key => "referrer"
  has_many :invites, :foreign_key => "referee"
  
  validates :email, uniqueness: true
  
  validate :valid_email, :on => :update
  
  def valid_email
    unless email.present? && email.match(/\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/).present?
      errors.add(:email, 'is not a valid email address')
    end
  end
end