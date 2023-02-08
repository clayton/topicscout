class Tweet < ApplicationRecord
  include ActionView::RecordIdentifier

  has_many :url_entities
  has_many :urls, through: :url_entities

  has_many :hashtag_entities
  has_many :hashtags, through: :hashtag_entities

  belongs_to :twitter_search_result
  belongs_to :topic

  before_save :calculate_score

  # after_create :fetch_embed_html

  after_create_commit :broadcast_create

  scope :newest, -> { order(tweeted_at: :desc) }
  scope :recent, -> { order(tweeted_at: :desc).limit(40) }
  scope :ignored, -> { where(ignored: true) }
  scope :relevant, -> { where(ignored: false) }
  scope :qualified, -> (threshold) { where(['score > ?', threshold]) }
  scope :best, -> { order(score: :desc) }

  def url
    "https://twitter.com/#{username}/status/#{tweet_id}"
  end

  def fetch_embed_html
    FetchTweetEmbedJob.perform_later(self)
  end

  def public_metrics=(metrics)
    self.retweet_count = metrics['retweet_count']
    self.reply_count = metrics['reply_count']
    self.like_count = metrics['like_count']
    self.quote_count = metrics['quote_count']
    self.impression_count = metrics['impression_count']
  end

  def calculate_score
    self.score = (impression_count + (like_count * 5) + (retweet_count * 20))
  end

  def broadcast_create
    broadcast_append_later_to topic, target: 'tweets', partial: 'tweets/tweet', locals: { tweet: self }

    return unless score > topic.threshold

    broadcast_prepend_later_to dom_id(topic, 'managed'), target: dom_id(topic, 'managed_tweets'), partial: 'tweets/listed_tweet',
                                                         locals: { tweet: self, topic: topic }
  end
end
