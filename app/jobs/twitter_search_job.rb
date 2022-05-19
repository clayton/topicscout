class TwitterSearchJob < ApplicationJob
  queue_as :default

  def perform(twitter_search_result)
    client = Tweetkit::Client.new(bearer_token: ENV['TWITTER_BEARER_TOKEN'])

    options = { 'expansions' => 'author_id', 'tweet.fields' => 'created_at', 'user.fields' => 'username,profile_image_url', 'max_results' => twitter_search_result.max_results }
    options.merge!('since_id' => twitter_search_result.since_id) if twitter_search_result.since_id
    options.merge!('start_time' => twitter_search_result.parsed_start_time) if twitter_search_result.start_time
    results = client.search(twitter_search_result.search_phrase, **options) do
      is_not :retweet
    end

    Rails.logger.debug("TwitterSearchJob: #{twitter_search_result.search_phrase}")
    Rails.logger.debug("results: #{results.inspect}")
    Rails.logger.debug("\n\n----------------------------------------------------------------")

    TwitterSearchResultParser.parse(results, twitter_search_result, nil)
    twitter_search_result.update(completed: true)
  end
end
