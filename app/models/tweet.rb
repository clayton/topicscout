class Tweet < ApplicationRecord
  belongs_to :twitter_search_result
  belongs_to :topic

  after_create :fetch_embed_html

  broadcasts_to :topic

  scope :newest, -> { order(tweeted_at: :desc) }
  scope :recent, -> { order(tweeted_at: :desc).limit(10) }
  scope :ignored, -> { where(ignored: true) }
  scope :relevant, -> { where(ignored: false) }

  def url
    "https://twitter.com/#{username}/status/#{tweet_id}"
  end

  def fetch_embed_html
    FetchTweetEmbedJob.perform_later(self)
  end
end
