class TwitterListSearchJob < ApplicationJob
  queue_as :default

  def perform(twitter_search_result, list_id, token)
    return unless twitter_search_result
    return unless twitter_search_result.topic
    return unless token
    return unless list_id
    return if list_id.blank?


    topic = twitter_search_result.topic

    client = Birder::Client.new(topic.user_auth_token)

    raw = client.list.tweets(list_id)

    TweetsParser.parse(raw, twitter_search_result, list_id) do |parser|
      twitter_search_result.increment!(:results_count, parser.results_count)
      twitter_search_result.increment!(:ignored_count, parser.ignored_count)
      twitter_search_result.increment!(:added_count, parser.added_count)
      Rails.logger.debug("[TwitterListSearchJob] Finished for (#{twitter_search_result.topic.name}) #{parser.results_count} results, #{parser.ignored_count} ignored, #{parser.added_count} added")
    end
  rescue StandardError => e
    Rails.logger.debug("[TwitterSearchJob] #{e.message} #{e.backtrace}}")
    twitter_search_result.update(errored: true, completed: true, error_message: e.message)
    Honeybadger.notify(e)
  end
end
