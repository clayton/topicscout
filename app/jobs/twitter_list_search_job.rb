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

    twitter_search_result.update(debug_description: raw.debug)

    TweetsParser.parse(raw, twitter_search_result, list_id) do |parser|
      twitter_search_result.increment!(:results_count, parser.results_count)
      twitter_search_result.increment!(:ignored_count, parser.ignored_count)
      twitter_search_result.increment!(:added_count, parser.added_count)
      twitter_search_result.update(completed: true)
    end
  rescue StandardError => e
    twitter_search_result.update(errored: true, completed: true, error_message: e.message)
    Honeybadger.notify(e)
  end
end
