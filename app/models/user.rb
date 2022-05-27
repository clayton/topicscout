class User < ApplicationRecord
  has_many :topics
  has_many :email_verifications, dependent: :destroy

  after_update :verify_email

  scope :verified, -> { where(email_verified: true) }
  
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

  def email=(email)
    return unless email

    self[:email] = email.downcase.strip
  end

  def verify_email
    return if email.nil?
    return if email.empty?
    return unless saved_change_to_email?
    return if email_verifications.pending_for(email).any?

    email_verifications.pending.destroy_all
    update(email_verified: false)

    email_verifications.create(email: email)
  end

end
