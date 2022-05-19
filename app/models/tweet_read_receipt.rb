class TweetReadReceipt < ApplicationRecord
  belongs_to :tweet
  belongs_to :user
  belongs_to :interest
end
