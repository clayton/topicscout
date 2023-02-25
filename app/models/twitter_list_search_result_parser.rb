class TwitterListSearchResultParser
  def self.parse(results, twitter_search_result, list, intent = nil)
    return unless results
    return unless results.tweets
    return if results.tweets.nil?
    return if results.tweets.empty?

    parser = TwitterListSearchResultParser.new(results, twitter_search_result, list, intent)
    parser.parse
  end

  def initialize(results, twitter_search_result, list, intent)
    @results = results
    @twitter_search_result = twitter_search_result
    @intent = intent
    @results_count = 0
    @topic = @twitter_search_result.topic
    @newest_id = nil
    @list = list
  end

  def parse

    save_tweets(@results)

    while @results.fetch('meta', {}).fetch('next_token', nil) && @results_count < @twitter_search_result.max_results
      save_tweets(@results)
      @results.next_page
    end

    Rails.logger.info("TwitterListSearchResultParser: Completed search result for #{@twitter_search_result.id} of #{@results_count} tweets")

    @twitter_search_result.update(results_count: @results_count, completed: true)

    self
  rescue StandardError => e
    Rails.logger.debug "TwitterListSearchResultParser: #{e} \n #{e.backtrace.join('\n')}"
    Honeybadger.notify(e)
  end

  def save_tweets(results)
    return unless results.fetch('data', nil)

    users = results.fetch('includes', {}).fetch('users', [])

    found_tweets = results.fetch('data', [])
    @results_count += found_tweets.count

    found_tweets.each do |tweet|
      tweet_author_id = tweet.fetch('author_id', nil)
      next if @twitter_search_result.ignored_authors.include?(tweet_author_id)

      entities = tweet.fetch('entities', {})
      hashtags = parse_hashtags(entities)
      urls = parse_urls(entities)

      @topic.tweets.find_or_create_by(tweet_id: tweet.fetch('id', nil)) do |t|
        t.twitter_list_id = @list.twitter_list_id
        t.twitter_search_result = @twitter_search_result
        t.name = users.find { |user| user.fetch('id', nil) == tweet_author_id }.fetch('name', nil)
        t.profile_image_url = users.find { |user| user.fetch('id', nil) == tweet_author_id }.fetch('profile_image_url', nil)
        t.username = users.find { |user| user.fetch('id', nil) == tweet_author_id }.fetch('username', nil)
        t.twitter_search_result = @twitter_search_result
        t.text = tweet.fetch('text', nil)
        t.tweet_id = tweet.fetch('id', nil)
        t.author_id = tweet_author_id
        t.intent = @intent
        t.tweeted_at = tweet.fetch('created_at', nil)
        t.public_metrics = tweet.fetch('public_metrics', {})
        t.lang = tweet.fetch('lang', nil)
        t.hashtags << hashtags.map { |hashtag| t.hashtags.build(tag: hashtag) }
        t.urls << urls.map { |url| t.urls.build(url) }
      end

      @newest_id = tweet.fetch('id', nil)
    end
  end

  def parse_hashtags(entities)
    return [] unless entities

    entities.fetch('hashtags', []).map { |h| h.fetch('tag', nil) }
  end

  def parse_urls(entities)
    return [] unless entities

    entities.fetch('urls', []).map do |url|
      { status: url.fetch('status', nil), title: url.fetch('title', nil), display_url: url.fetch('display_url', nil),
        unwound_url: url.fetch('unwound_url', nil) }
    end
  end
end
