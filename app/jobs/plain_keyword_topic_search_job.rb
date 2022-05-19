class PlainKeywordTopicSearchJob < ApplicationJob
  queue_as :default

  def perform(twitter_search_result)
    phrase = twitter_search_result&.topic&.topic
    return unless phrase

    client = Tweetkit::Client.new(bearer_token: ENV['TWITTER_BEARER_TOKEN'])
    results = client.search(%("#{phrase}" -has:links -is:retweet), max_results: 50)
    Rails.logger.debug("Results: #{results.twitter_request.inspect}")

    TwitterSearchResultParser.parse(results, twitter_search_result, "mentioned")
  end
end
