class User < ApplicationRecord
  has_one :subscription
  has_one :twitter_account
  has_many :topics
  has_many :email_verifications, dependent: :destroy
  has_many :email_authentications, dependent: :destroy

  after_update :verify_email

  scope :verified, -> { where(email_verified: true) }
  
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

  def onboarding?
    topics.empty?
  end

  def image
    twitter_account&.image
  end

end
