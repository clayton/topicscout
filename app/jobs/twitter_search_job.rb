class TwitterSearchJob < ApplicationJob
  queue_as :default

  def perform(twitter_search_result)
    client = Birder::Client.new(Rails.application.credentials.twitter.bearer_token)

    topic = twitter_search_result.topic
    query = topic.to_query

    raw = client.search.tweets(query, start_time: twitter_search_result.parsed_start_time)

    TweetsParser.parse(raw, twitter_search_result, nil) do |parser|
      twitter_search_result.update!(completed: true)

      twitter_search_result.increment!(:results_count, parser.results_count)
      twitter_search_result.increment!(:ignored_count, parser.ignored_count)
      twitter_search_result.increment!(:added_count, parser.added_count)
      Rails.logger.debug("[TwitterSearchJob] Finished for (#{twitter_search_result.topic.name}) #{parser.results_count} results, #{parser.ignored_count} ignored, #{parser.added_count} added")
    end
  rescue StandardError => e
    Rails.logger.debug("[TwitterSearchJob] #{e.message} #{e.backtrace}}")
    twitter_search_result.update(errored: true, completed: true, error_message: e.message)
    Honeybadger.notify(e)
  end
end
