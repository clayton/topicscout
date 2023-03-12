class Tweet < ApplicationRecord
  include ActionView::RecordIdentifier

  has_many :hashtag_entities
  has_many :tweeted_urls
  has_many :urls, through: :tweeted_urls
  has_many :hashtags

  belongs_to :influencer
  belongs_to :twitter_search_result
  belongs_to :topic
  belongs_to :collection, optional: true
  belongs_to :twitter_list, optional: true

  before_save :calculate_score

  after_create_commit :broadcast_create

  after_save_commit :promote_to_list
  after_save_commit :fetch_embed_html
  after_save :update_influencer_metrics

  scope :unedited, -> { where(saved: false, archived: false) }
  scope :newest, -> { order(published_at: :desc) }
  scope :recent, -> { order(published_at: :desc).limit(40) }
  scope :ignored, -> { where(ignored: true) }
  scope :relevant, -> { where(ignored: false) }
  scope :qualified, ->(threshold) { where(['score >= ?', threshold]) }
  scope :best, -> { order(score: :desc) }
  scope :reviewing, -> { where(ignored: false, saved: true, archived: false, collection_id: nil) }
  scope :uncollected, -> { where(collection_id: nil) }
  scope :collected, -> { where.not(collection_id: nil) }
  scope :unsaved, -> { where(saved: false) }
  scope :unarchived, -> { where(archived: false) }

  def url
    "https://twitter.com/#{influencer&.username}/status/#{tweet_id}"
  end

  def username
    influencer&.username || 'unknown'
  end

  def name
    influencer&.name || 'unknown'
  end

  def profile_image_url
    influencer&.profile_image_url || ''
  end

  def author_id
    influencer&.platform_id || 'unknown'
  end

  def public_metrics=(metrics)
    self.retweet_count = metrics['retweet_count']
    self.reply_count = metrics['reply_count']
    self.like_count = metrics['like_count']
    self.quote_count = metrics['quote_count']
    self.impression_count = metrics['impression_count']
  end

  def calculate_score
    follower_count = if influencer.nil? || influencer&.followers_count.zero?
                       1
                     else
                       influencer&.followers_count
                     end

    # Old scoring
    # raw_score = ((impression_count / (follower_count * 0.25)) + ((like_count / (follower_count * 0.02)) + ((retweet_count / (follower_count * 0.002)))))

    # New scoring
    # =(MIN($impressions/(followers*0.0994),10)+(MIN($likes/(followers*0.00069),10)+(MIN($retweets/(followers*0.0001),10))))*(len(followers)

    impression_score = [(impression_count / (follower_count * 0.0994)), 5].min
    like_score = [(like_count / (follower_count * 0.00069)), 5].min
    retweet_score = [(retweet_count / (follower_count * 0.0001)), 5].min

    raw_score = impression_score + like_score + retweet_score
    raw_score *= follower_count.to_s.length.to_i

    self.score = raw_score
  end

  def broadcast_create
    return if topic.twitter_search_results.count > 1

    broadcast_append_later_to topic, target: 'tweets', partial: 'tweets/tweet', locals: { tweet: self }
  end

  def promote_to_list
    return unless saved? && saved_change_to_collection_id?

    add_to_twitter_list
  end

  def add_to_twitter_list
    list_id = topic.twitter_lists.managed.first&.twitter_list_id

    return if list_id.blank?

    PromoteUserToListJob.perform_later(
      topic.user_auth_token,
      list_id,
      author_id
    )
  end

  def fetch_embed_html
    return if embed_html.present?
    return unless saved? && saved_change_to_collection_id?

    FetchTweetEmbedJob.perform_later(self)
  end

  def edited_tweet_ids=(tweet_ids)
    tweet_ids.each do |id|
      Tweet.unsaved.uncollected.where(tweet_id: id).first&.update(archived: true)
    end
  end

  def update_influencer_metrics
    return unless saved?
    return unless influencer
    return unless saved_change_to_collection_id? || saved_change_to_saved?

    if saved_change_to_collection_id?
      influencer.update(collected_tweets: true)
      influencer.increment!(:collected_count)
    elsif saved_change_to_saved?
      influencer.update(saved_tweets: true)
      influencer.increment!(:saved_count)
    end
  end
end
