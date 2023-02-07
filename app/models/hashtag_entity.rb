class HashtagEntity < ApplicationRecord
  belongs_to :topic
  belongs_to :tweet
  belongs_to :hashtag
end
