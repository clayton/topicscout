class TweeterIgnoreRule < ApplicationRecord
  belongs_to :topic

  after_create_commit :ignore_tweets

  def ignore_tweets
    topic.tweets.where(author_id: author_id).update_all(ignored: true)
  end
end
