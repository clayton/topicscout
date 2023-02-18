class Collection < ApplicationRecord
  belongs_to :user
  belongs_to :topic
  has_many :tweets

  scope :newest, -> { order(created_at: :desc).limit(1) }
end
