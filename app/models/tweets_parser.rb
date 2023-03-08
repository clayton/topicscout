class TweetsParser
  attr_reader :results_count, :ignored_count, :added_count, :newest_tweet_id

  def self.parse(results, twitter_search_result, list, intent = nil)
    parser = TweetsParser.new(results, twitter_search_result, list, intent)
    parser.parse
    yield parser if block_given?
  end

  def initialize(results, twitter_search_result, list_id, intent)
    @results = results || {}
    @twitter_search_result = twitter_search_result
    @intent = intent
    @results_count = 0
    @ignored_count = 0
    @added_count = 0
    @topic = @twitter_search_result.topic
    @newest_tweet_id = nil
    @list_id = list_id || nil
  end

  def parse
    save_tweets(@results.to_h)

    save_tweets(@results.to_h) while (@results = @results.next) && @twitter_search_result.under_limit(@results_count)

    yield self if block_given?
  rescue StandardError => e
    @twitter_search_result.update(errored: true, completed: true, error_message: e.message)
    Honeybadger.notify(e)
  end

  def save_tweets(results)
    return unless results.fetch('data', nil)

    users = results.fetch('includes', {}).fetch('users', [])

    found_tweets = results.fetch('data', [])
    @results_count += found_tweets.count

    found_tweets.each do |tweet|
      tweet_author_id = tweet.fetch('author_id', nil)
      if @twitter_search_result.ignored_authors.include?(tweet_author_id)
        @ignored_count += 1
        next
      end

      matching_user = users.find { |user| user.fetch('id', nil) == tweet_author_id } || {}

      next if just_a_retweet(tweet)

      entities = tweet.fetch('entities', {})
      hashtags = parse_hashtags(entities)
      edited_tweets = parse_edited_tweets(tweet)

      influencer = find_or_create_influencer(tweet, users)
      urls = find_or_create_urls(entities, influencer, tweet)

      created_tweet = @topic.tweets.find_or_create_by!(tweet_id: tweet.fetch('id', nil)) do |t|
        t.author_id = tweet_author_id
        t.author_name = matching_user.fetch('name', nil)
        t.author_username = matching_user.fetch('username', nil)
        t.author_profile_image_url = matching_user.fetch('profile_image_url', nil)
        t.influencer = influencer
        t.twitter_list_id = @list_id
        t.twitter_search_result = @twitter_search_result
        t.text = tweet.fetch('text', nil)
        t.tweet_id = tweet.fetch('id', nil)
        t.tweeted_at = tweet.fetch('created_at', nil)
        t.public_metrics = tweet.fetch('public_metrics', {})
        t.lang = tweet.fetch('lang', nil)
        t.hashtags << hashtags.compact.map { |hashtag| t.hashtags.build(tag: hashtag) }
        t.edited_tweet_ids = edited_tweets
      end

      urls.each do |url| 
        url.increment!(:score, created_tweet.score)
        TweetedUrl.find_or_create_by(tweet: created_tweet, url: url)
      end

      influencer.increment!(:influenced_count)

      @added_count += 1 if created_tweet.previously_new_record?

      @newest_tweet_id = tweet.fetch('id', nil)
    end
  end

  def just_a_retweet(tweet)
    referenced_tweets = tweet.fetch('referenced_tweets', [])

    return false if referenced_tweets.empty?
    
    first_tweet = referenced_tweets.first
    type = first_tweet.fetch('type', nil)

    type == 'retweeted'
  end

  def parse_edited_tweets(tweet)
    history = tweet.fetch('edit_history_tweet_ids', [])
    history.shift # remove the original tweet
    history || []
  end

  def find_or_create_influencer(tweet, users)
    platform_id = tweet.fetch('author_id', nil)
    return unless platform_id

    matching_user = users.find { |user| user.fetch('id', nil) == platform_id } || {}

    name = matching_user.fetch('name', nil)
    profile_image_url = matching_user.fetch('profile_image_url', nil)
    username = matching_user.fetch('username', nil)
    verified = matching_user.fetch('verified', false)
    verified_type = matching_user.fetch('verified_type', nil)
    public_metrics = matching_user.fetch('public_metrics', {})
    followers_count = public_metrics.fetch('followers_count', 0)
    following_count = public_metrics.fetch('following_count', 0)
    tweet_count = public_metrics.fetch('tweet_count', 0)
    listed_count = public_metrics.fetch('listed_count', 0)

    influencer = Influencer.find_or_create_by(topic: @topic, platform_id: platform_id)

    influencer.update(
      name: name,
      profile_image_url: profile_image_url,
      username: username,
      verified: verified,
      verified_type: verified_type,
      followers_count: followers_count,
      following_count: following_count,
      tweet_count: tweet_count,
      listed_count: listed_count,
      platform: 'twitter',
      profile_url: "https://twitter.com/#{username}"
    )

    influencer
  end

  def parse_hashtags(entities)
    return [] unless entities

    entities.fetch('hashtags', []).map { |h| h.fetch('tag', nil) }
  end

  def find_or_create_urls(entities, influencer, tweet)
    return [] unless entities

    created_urls = []

    entities.fetch('urls', []).map do |url|
      next unless url.fetch('title', nil)
      next if url.fetch('title', nil).empty?
      next unless url.fetch('unwound_url', nil)
      next if url.fetch('unwound_url', nil).empty?
      next if @twitter_search_result.ignored_hostname?(url.fetch('unwound_url', nil))

      unwound_url = url.fetch('unwound_url', nil)

      next if unwound_url.nil?

      url_hash = Digest::SHA256.hexdigest(unwound_url)

      created_url = @topic.urls.find_or_create_by(url_hash: url_hash) do |u|
        u.unwound_url = url.fetch('unwound_url', nil)
        u.url_hash = url_hash
        u.title = url.fetch('title', nil)
        u.display_url = url.fetch('display_url', nil)
        u.unwound_url = url.fetch('unwound_url', nil)
        u.status = url.fetch('status', nil)
        u.published_at = tweet.fetch('created_at', nil)
      end

      InfluencedUrl.find_or_create_by(influencer: influencer, url: created_url)

      created_urls << created_url
    end

    created_urls
  end
end
