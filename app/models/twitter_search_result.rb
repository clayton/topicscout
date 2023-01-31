class TwitterSearchResult < ApplicationRecord

  include Routeable

  belongs_to :topic
  has_many :tweets, dependent: :destroy

  after_create :search

  after_update :send_digest_if_completed

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

  def digest
    {
      topic: topic.topic,
      results_count: results_count,
      topic_tweets_url: topic_tweets_url(topic),
      edit_topic_url: edit_topic_url(topic),
      support_email: 'help@topicscout.app',
      tweets: tweets.limit(10).map do |t|
                { name: t.name, username: t.username, profile_image_url: t.profile_image_url, embed_html: t.embed_html }
              end
    }
  end

  def ignored_authors
    topic.tweeter_ignore_rules.map(&:author_id)
  end

  def excluded_language?(lang)
    return if topic.filter_by_language.blank?

    topic.filter_by_language.exclude?(lang)
  end

  def send_digest_if_completed
    return unless saved_change_to_completed? && completed?

    SendDailyDigestJob.perform_later(self)
  end
end
