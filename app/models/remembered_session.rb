class RememberedSession < ApplicationRecord
  belongs_to :user

  before_create :set_default_expiration
  before_create :generate_lookup
  before_create :generate_validator

  def cookie_value
    "#{lookup}.#{validator}"
  end

  private

  def set_default_expiration
    self.expires_at = 30.days.from_now
  end

  def generate_lookup
    self.lookup = Base64.strict_encode64(SecureRandom.bytes(9))
  end

  def generate_validator
    self.validator = Base64.strict_encode64(SecureRandom.bytes(24))
  end
end
