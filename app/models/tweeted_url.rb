class TweetedUrl < ApplicationRecord
  belongs_to :url
  belongs_to :tweet
end
