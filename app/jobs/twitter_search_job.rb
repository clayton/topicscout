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
    end
  rescue StandardError => e
    Rails.logger.debug("[TwitterSearchJob] #{e.message} #{e.backtrace}}")
    Honeybadger.notify(e)
  end
end
