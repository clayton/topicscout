class InfoKeywordTopicSearchJob < ApplicationJob
  queue_as :default

  def perform(twitter_search_result)
    phrase = twitter_search_result&.topic&.topic
    return unless phrase

    client = Tweetkit::Client.new(bearer_token: ENV['TWITTER_BEARER_TOKEN'])
    results = client.search(%{"#{phrase}" -is:retweet -free -has:links (guide OR "looking for" OR "top ten list" OR "shopping" OR "how to" OR "how can I" OR "where can I" OR comparison OR "find a")}, max_results: 50)
    Rails.logger.debug("Results: #{results.twitter_request.inspect}")

    TwitterSearchResultParser.parse(results, twitter_search_result, "researching")
  end
end
