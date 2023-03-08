class TwitterSearchResult < ApplicationRecord
  include Routeable

  belongs_to :topic
  has_many :tweets, dependent: :destroy

  after_create :search
  after_create :search_lists

  # after_update :send_digest

  scope :newest, -> { order(created_at: :desc) }
  scope :completed, -> { where(completed: true) }
  scope :incomplete, -> { where(completed: false) }
  scope :successful, -> { where(errored: false, completed: true) }
  scope :errored, -> { where(errored: true) }

  def incomplete?
    !completed?
  end

  def search_phrase
    topic.search_phrase
  end

  def list_id
    twitter_list&.twitter_list_id
  end

  def under_limit(count)
    return true unless limited?

    count < max_results
  end

  def search
    return if list_search?

    TwitterSearchJob.perform_later(self)
    update(query: topic.to_query)
  end

  def search_lists
    return unless list_search?

    topic.twitter_lists.map(&:twitter_list_id).compact.each do |list_id|
      TwitterListSearchJob.perform_later(self, list_id, topic.user_auth_token)
    end
  end

  def since_id
    topic.twitter_search_results.completed.order(created_at: :desc).first.try(:newest_tweet_id)
  end

  def parsed_start_time
    (Time.current - 250.minutes).rfc3339
  end

  def status
    return 'Errored' if errored?
    return 'Completed' if completed?

    'In progress'
  end

  def digest
    {
      topic: topic.name,
      results_count: results_count,
      topic_tweets_url: topic_tweets_url(topic),
      edit_topic_url: edit_topic_url(topic),
      support_email: 'help@topicscout.app',
      tweets: tweets.qualified(topic.threshold).limit(10).map do |t|
                { name: t.name, username: t.username, profile_image_url: t.profile_image_url, embed_html: t.text }
              end
    }
  end

  def ignored_authors
    topic.tweeter_ignore_rules.map(&:author_id)
  end

  def ignored_hostname?(url)
    ignores = topic.hostname_ignore_rules.map(&:hostname)

    begin
      url_hostname = URI.parse(url).hostname
    rescue StandardError => e
      Honeybadger.notify("#{e.message} - #{url}")
      return false
    end

    ignores.include?(url_hostname)
  end

  def send_digest
    return unless saved_change_to_completed? && completed?
    return if manual_search

    SendDailyDigestJob.perform_later(self)
  end
end
