class EmailAuthentication < ApplicationRecord
  belongs_to :user

  before_create :set_code

  scope :valid, -> { where('expires_at > ?', Time.current) }
  
  def set_code
    self.expires_at = Time.current + 15.minutes
    self.code = SecureRandom.random_number(99_999..999_999)
  end

  def send_code
    # Require gem:

    return Rails.logger.debug("Sending email to #{user.email} with code #{code}") if Rails.env.development?

    # Create an instance of Postmark::ApiClient:
    client = Postmark::ApiClient.new(Rails.application.credentials.postmark_api_token)

    # Example request
    client.deliver_with_template(
      { from: 'help@topicscoutapp.com',
        to: user.email,
        template_alias: Rails.application.credentials.postmark_email_auth_template,
        template_model: { 'product_url' => 'https://app.topicscoutapp.com',
                          'name' => user.name,
                          'product_name' => 'Topic Scout',
                          'code' => code,
                          'support_email' => 'help@topicscoutapp.com',
                          'sender_name' => 'Clayton',
                          'action_url' => 'https://app.topicscoutapp.com/profile',
                          'login_url' => 'https://app.topicscoutapp.com/login' } }
    )
  end
end
