class TwitterSearchResultParser
  def self.parse(results, twitter_search_result, intent = nil)
    return unless results
    return unless results.tweets
    return if results.tweets.nil?
    return if results.tweets.empty?

    parser = TwitterSearchResultParser.new(results, twitter_search_result, intent)
    parser.parse
  end

  def initialize(results, twitter_search_result, intent)
    @results = results
    @twitter_search_result = twitter_search_result
    @intent = intent
    @results_count = 0
    @topic = @twitter_search_result.topic
  end

  def parse
    newest_id = @results.meta&.data&.fetch('newest_id', nil)
    oldest_id = @results.meta&.data&.fetch('oldest_id', nil)

    @twitter_search_result.update(newest_tweet_id: newest_id, oldest_tweet_id: oldest_id)

    save_tweets(@results)

    while @results.meta&.data&.fetch('next_token', nil) && @results_count < @twitter_search_result.max_results
      save_tweets(@results)
      @results.next_page
    end

    Rails.logger.info("TwitterSearchResultParser: Completed search result for #{@twitter_search_result.id} of #{@results_count} tweets")

    @twitter_search_result.update(results_count: @results_count, completed: true)

    self
  rescue StandardError => e
    Rails.logger.debug "TwitterSearchResultParser: #{e} \n #{e.backtrace.join('\n')}"
    Honeybadger.notify(e)
  end

  def save_tweets(results)
    return unless results.tweets

    users = results.expansions&.users&.users

    found_tweets = results.tweets
    @results_count += found_tweets.count

    found_tweets.each do |tweet|
      next if @twitter_search_result.ignored_authors.include?(tweet.author_id)

      hashtags = parse_hashtags(tweet.entities)
      urls = parse_urls(tweet.entities)

      

      @topic.tweets.find_or_create_by(tweet_id: tweet.id) do |t|
        t.twitter_search_result = @twitter_search_result
        t.name = users.find { |user| user.id == tweet.author_id }.name
        t.profile_image_url = users.find { |user| user.id == tweet.author_id }.profile_image_url
        t.username = users.find { |user| user.id == tweet.author_id }.username
        t.twitter_search_result = @twitter_search_result
        t.text = tweet.text
        t.tweet_id = tweet.id
        t.author_id = tweet.author_id
        t.intent = @intent
        t.tweeted_at = tweet.created_at
        t.public_metrics = tweet.data['public_metrics'] || {}
        t.lang = tweet.lang
        t.hashtags << hashtags.map { |hashtag| t.hashtags.build(tag: hashtag) }
        t.urls << urls.map { |url| t.urls.build(url) }
      end

    end
  end

  def parse_hashtags(entities)
    return [] unless entities
    return [] unless entities.hashtags
    return [] unless entities.hashtags.hashtags

    entities.hashtags.hashtags.map(&:tag)
  end

  def parse_urls(entities)
    return [] unless entities
    return [] unless entities.urls
    return [] unless entities.urls.urls

    entities.urls.urls.map do |url|
      { status: url.status, title: url.title, display_url: url.display_url, unwound_url: url.unwound_url }
    end
  end
end
