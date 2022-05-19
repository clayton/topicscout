class BuyingKeywordTopicSearchJob < ApplicationJob
  queue_as :default

  def perform(twitter_search_result)
    phrase = twitter_search_result&.topic&.topic
    return unless phrase

    client = Tweetkit::Client.new(bearer_token: ENV['TWITTER_BEARER_TOKEN'])
    results = client.search(%{"#{phrase}" -is:retweet -free -has:links (best OR recommended OR "looking for" OR reliable OR top OR suggested OR buy OR "high price" OR review OR "that works" OR "top 10" OR discount)}, max_results: 50)
    Rails.logger.debug("Results: #{results.twitter_request.inspect}")

    TwitterSearchResultParser.parse(results, twitter_search_result, "buying")
  end
end
