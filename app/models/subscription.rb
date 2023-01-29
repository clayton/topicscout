class Subscription < ApplicationRecord
  belongs_to :user

  validates :stripe_subscription_id, presence: true
  validates :stripe_customer_id, presence: true
  validates :status, inclusion: { in: %w[incomplete incomplete_expired trialing active past_due canceled unpaid complete] }
end
