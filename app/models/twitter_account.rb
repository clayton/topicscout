class TwitterAccount < ApplicationRecord
  belongs_to :user

  encrypts :auth_token
  encrypts :refresh_token

  scope :expiring, -> { where('auth_token_expires_at < ?', Time.current + 1.hour) }

  def self.find_or_create_from_auth_hash(auth_hash)
    user_id = auth_hash[:user_id]
    uid = auth_hash[:uid]
    name = auth_hash[:info][:name]
    nickname = auth_hash[:info][:nickname]
    image = auth_hash[:info][:image]
    provider = auth_hash[:provider]
    auth_token = auth_hash[:credentials][:token]
    refresh_token = auth_hash[:credentials][:refresh_token]

    begin
      expires_at = Time.at(auth_hash[:credentials][:expires_at]).to_datetime.in_time_zone('UTC')
    rescue StandardError => e
      Honeybadger.notify(e)
      expires_at = Time.current + 2.hours.from_now
    end

    TwitterAccount.find_or_create_by(uid: uid) do |account|
      account.provider = provider
      account.name = name
      account.username = nickname
      account.image = image
      account.user_id = user_id
      account.auth_token = auth_token
      account.refresh_token = refresh_token
      account.auth_token_expires_at = expires_at
    end
  end

  def refresh_auth_token!
    RefreshTokenJob.perform_later(self)
  end
end
