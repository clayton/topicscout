class TwitterAccount < ApplicationRecord
  belongs_to :user

  def self.find_or_create_from_auth_hash(auth_hash)
    user_id = auth_hash[:user_id]
    uid = auth_hash[:uid]
    name = auth_hash[:info][:name]
    nickname = auth_hash[:info][:nickname]
    image = auth_hash[:info][:image]
    provider = auth_hash[:provider]

    TwitterAccount.find_or_create_by(uid: uid) do |account|
      account.provider = provider
      account.name = name
      account.username = nickname
      account.image = image
      account.user_id = user_id
    end
  end
end
