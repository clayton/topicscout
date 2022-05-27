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
    @result_count = 0
  end

  def parse
    newest_id = @results.meta&.data&.fetch('newest_id', nil)
    oldest_id = @results.meta&.data&.fetch('oldest_id', nil)

    @twitter_search_result.update(newest_tweet_id: newest_id, oldest_tweet_id: oldest_id)

    save_tweets(@results)

    if @twitter_search_result.limited?
      @twitter_search_result.update(result_count: @result_count, completed: true)
      return self
    end

    while @results.meta&.data&.fetch('next_token', nil)
      save_tweets(@results)
      @results.next_page
    end

    @twitter_search_result.update(result_count: @result_count, completed: true)

    self
  end

  def save_tweets(results)
    return unless results.tweets

    users = results.expansions&.users&.users

    found_tweets = results.tweets
    @result_count += found_tweets.count

    found_tweets.each do |tweet|
      Tweet.find_or_create_by(tweet_id: tweet.id) do |t|
        t.twitter_search_result = @twitter_search_result
        t.name = users.find { |user| user.id == tweet.author_id }.name
        t.profile_image_url = users.find { |user| user.id == tweet.author_id }.profile_image_url
        t.username = users.find { |user| user.id == tweet.author_id }.username
        t.twitter_search_result = @twitter_search_result
        t.topic = @twitter_search_result.topic
        t.text = tweet.text
        t.tweet_id = tweet.id
        t.author_id = tweet.author_id
        t.intent = @intent
        t.tweeted_at = tweet.created_at
      end
    end
  end
end
