class TwitterSearchJob < ApplicationJob
  queue_as :default

  def perform(twitter_search_result)
    client = Birder::Client.new(Rails.application.credentials.twitter.bearer_token)

    topic = twitter_search_result.topic
    query = topic.to_query

    options = {}
    options[:since_id] = twitter_search_result.newest_tweet_id if twitter_search_result.newest_tweet_id.present?
    options[:start_time] = twitter_search_result.parsed_start_time unless twitter_search_result.newest_tweet_id.present?

    raw = client.search.tweets(query, options)

    twitter_search_result.update(debug_description: raw.debug)

    TweetsParser.parse(raw, twitter_search_result, nil) do |parser|
      twitter_search_result.update!(completed: true)

      twitter_search_result.increment!(:results_count, parser.results_count)
      twitter_search_result.increment!(:ignored_count, parser.ignored_count)
      twitter_search_result.increment!(:added_count, parser.added_count)
      twitter_search_result.update(newest_tweet_id: parser.newest_tweet_id)
    end
  rescue StandardError => e
    twitter_search_result.update(errored: true, completed: true, error_message: e.message)
    Honeybadger.notify(e)
  end
end
