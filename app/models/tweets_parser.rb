class TweetsParser
  attr_reader :results_count, :ignored_count, :added_count

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
    @newest_id = nil
    @list_id = list_id || nil
  end

  def parse
    save_tweets(@results.to_h)

    save_tweets(@results.to_h) while (@results = @results.next) && @twitter_search_result.under_limit(@added_count)

    yield self if block_given?
  rescue StandardError => e
    Rails.logger.debug "TweetsParser: #{e} \n #{e.backtrace.join('\n')}"
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

      entities = tweet.fetch('entities', {})
      hashtags = parse_hashtags(entities)
      urls = parse_urls(entities)
      edited_tweets = parse_edited_tweets(tweet)

      @topic.tweets.find_or_create_by!(tweet_id: tweet.fetch('id', nil)) do |t|
        t.twitter_list_id = @list_id
        t.twitter_search_result = @twitter_search_result
        t.name = users.find { |user| user.fetch('id', nil) == tweet_author_id }.fetch('name', nil)
        t.profile_image_url = users.find do |user|
          user.fetch('id', nil) == tweet_author_id
        end.fetch('profile_image_url', nil)
        t.username = users.find { |user| user.fetch('id', nil) == tweet_author_id }.fetch('username', nil)
        t.twitter_search_result = @twitter_search_result
        t.text = tweet.fetch('text', nil)
        t.tweet_id = tweet.fetch('id', nil)
        t.author_id = tweet_author_id
        t.intent = @intent
        t.tweeted_at = tweet.fetch('created_at', nil)
        t.public_metrics = tweet.fetch('public_metrics', {})
        t.lang = tweet.fetch('lang', nil)
        t.hashtags << hashtags.compact.map { |hashtag| t.hashtags.build(tag: hashtag) }
        t.urls << urls.compact.map { |url| t.urls.build(url) }
        t.edited_tweet_ids = edited_tweets
      end

      @added_count += 1

      @newest_id = tweet.fetch('id', nil)
    end
  end

  def parse_edited_tweets(tweet)
    history = tweet.fetch('edit_history_tweet_ids', [])
    history.shift # remove the original tweet
    history || []
  end

  def parse_hashtags(entities)
    return [] unless entities

    entities.fetch('hashtags', []).map { |h| h.fetch('tag', nil) }
  end

  def parse_urls(entities)
    return [] unless entities

    entities.fetch('urls', []).map do |url|
      next unless url.fetch('title', nil)
      next if url.fetch('title', nil).empty?
      next unless url.fetch('unwound_url', nil)
      next if url.fetch('unwound_url', nil).empty?
      next if @twitter_search_result.ignored_hostname?(url.fetch('unwound_url', nil))

      {
        topic_id: @topic.id,
        status: url.fetch('status', nil),
        title: url.fetch('title', nil),
        display_url: url.fetch('display_url', nil),
        unwound_url: url.fetch('unwound_url', nil)
      }
    end
  end
end
