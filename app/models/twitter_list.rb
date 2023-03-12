class TwitterList < ApplicationRecord
  has_many :tweets
  has_many :twitter_list_memberships
  belongs_to :topic

  scope :managed, -> { where(managed: true) }
end
