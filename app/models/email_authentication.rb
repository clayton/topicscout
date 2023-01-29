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

    # Create an instance of Postmark::ApiClient:
    client = Postmark::ApiClient.new(Rails.application.credentials.postmark_api_token)

    # Example request
    client.deliver_with_template(
      { from: 'help@topicscout.app',
        to: user.email,
        template_alias: Rails.application.credentials.postmark_email_auth_template,
        template_model: { 'product_url' => 'https://go.topicscout.app',
                          'name' => user.name,
                          'product_name' => 'Topic Scout',
                          'code' => code,
                          'support_email' => 'help@topicscout.app',
                          'sender_name' => 'Clayton',
                          'action_url' => 'https://go.topicscout.app/profile',
                          'login_url' => 'https://go.topicscout.app/login' } }
    )
  end
end
