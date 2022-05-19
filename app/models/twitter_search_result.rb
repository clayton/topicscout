class TwitterSearchResult < ApplicationRecord
  belongs_to :topic

  after_create :search

  scope :completed, -> { where(completed: true) }

  def search_phrase
    topic.search_phrase
  end

  def search
    TwitterSearchJob.perform_later(self)
  end

  def since_id
    topic.twitter_search_results.completed.order(created_at: :desc).first.try(:newest_tweet_id)
  end

  def parsed_start_time
    start_time&.rfc3339
  end
end
