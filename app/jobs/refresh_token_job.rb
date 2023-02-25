class RefreshTokenJob < ApplicationJob
  queue_as :priority

  def perform(account)
    return unless account
    return unless account.refresh_token

    begin
      url = 'https://api.twitter.com/2/oauth2/token'
      body = { 'grant_type' => 'refresh_token', 'refresh_token' => account.refresh_token }
      headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }

      connection = Faraday.new(url: url) do |conn|
        conn.request :url_encoded
        conn.basic_auth(Rails.application.credentials.twitter.client_id,
                        Rails.application.credentials.twitter.client_secret)
        conn.adapter Faraday.default_adapter
      end

      response = connection.post(url, body, headers)

      if response.success?
        json = JSON.parse(response.body)

        account.update(
          auth_token: json['access_token'],
          auth_token_expires_at: Time.current + json['expires_in'].seconds,
          refresh_token: json['refresh_token']
        )
      else
        account.destroy
      end
    rescue StandardError => e
      Honeybadger.notify(e)
      account.destroy
    end
  end
end
