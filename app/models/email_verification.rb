require 'postmark'

class EmailVerification < ApplicationRecord
  belongs_to :user

  before_create :set_code
  after_create_commit :send_verification
  after_update :update_user

  scope :pending, -> { where(verified: false) }
  scope :pending_for, ->(email) { where(email: email, verified: false) }
  scope :verified, -> { where(verified: true) }

  def set_code
    self.code = SecureRandom.random_number(99_999..999_999)
  end

  def update_user
    user.update(email_verified: true) if verified?
  end

  def send_verification
    # Require gem:

    # Create an instance of Postmark::ApiClient:
    client = Postmark::ApiClient.new(Rails.application.credentials.postmark_api_token)

    # Example request
    client.deliver_with_template(
      { from: 'help@topicscout.app',
        to: email,
        template_alias: 'verify_email',
        template_model: { 'product_url' => 'https://topicscout.fly.dev',
                          'name' => user.name,
                          'product_name' => 'Topic Scout',
                          'code' => code,
                          'support_email' => 'help@topicscout.app',
                          'sender_name' => 'Clayton',
                          'action_url' => 'https://topicscout.fly.dev/profile',
                          'login_url' => 'https://topicscout.fly.dev/login' } }
    )
  end
end
