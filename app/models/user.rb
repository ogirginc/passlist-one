class User < ApplicationRecord
  validates :name, presence: true

  # Disable default password validations as there is no need for confirmation.
  has_secure_password validations: false
  validate :strong_password, if: -> { password.present? }

  MINIMUM_PASSWORD_LENGTH = 10
  MAXIMUM_PASSWORD_LENGTH = 16

  private

  def strong_password
    return if password.blank?

    unless password.length.between?(MINIMUM_PASSWORD_LENGTH, MAXIMUM_PASSWORD_LENGTH)
      errors.add(:password, "must be between #{MINIMUM_PASSWORD_LENGTH} and #{MAXIMUM_PASSWORD_LENGTH} characters")
    end

    errors.add(:password, "must contain at least one lowercase letter") unless password =~ /[a-z]/
    errors.add(:password, "must contain at least one uppercase letter") unless password =~ /[A-Z]/
    errors.add(:password, "must contain at least one digit") unless password =~ /\d/
    errors.add(:password, "cannot contain three repeating characters") if password =~ /(.)\1\1/
  end
end
