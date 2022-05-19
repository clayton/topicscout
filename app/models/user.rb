class User < ApplicationRecord
  has_many :interests
  has_many :topics, through: :interests
  
  def self.find_or_create_from_auth_hash(auth_hash)
    uid = auth_hash[:uid]
    name = auth_hash[:info][:name]
    nickname = auth_hash[:info][:nickname]
    email = auth_hash[:info][:email]
    image = auth_hash[:info][:image]
    provider = auth_hash[:provider]

    User.find_or_create_by(uid: uid) do |user|
      user.provider = provider
      user.name = name
      user.username = nickname
      user.email = email
      user.image = image
    end
  end
end
