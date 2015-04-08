class EmailValidator < ActiveModel::Validator
  def validate(record)
    unless record.email.present? && record.email.match(/\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/).present?
      record.errors.add(:email, 'is not a valid email address')
    end
  end
end