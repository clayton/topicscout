class TwitterList < ApplicationRecord
  has_many :tweets
  belongs_to :topic

  scope :managed, -> { where(managed: true) }
end
