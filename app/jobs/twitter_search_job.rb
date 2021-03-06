class TwitterSearchJob < ApplicationJob
  queue_as :default

  def perform(twitter_search_result)
    begin
      client = Tweetkit::Client.new(bearer_token: ENV['TWITTER_BEARER_TOKEN'])

      options = { 'expansions' => 'author_id', 'tweet.fields' => 'created_at',
                  'user.fields' => 'username,profile_image_url', 'max_results' => twitter_search_result.max_results }
      options.merge!('since_id' => twitter_search_result.since_id) if twitter_search_result.since_id
      options.merge!('start_time' => twitter_search_result.parsed_start_time) if twitter_search_result.start_time

      Rails.logger.info("[TwitterSearchJob] query:#{twitter_search_result.search_phrase} \n options: #{options}\n\n")
      results = client.search(twitter_search_result.search_phrase, **options) do
        is_not :retweet
      end

      TwitterSearchResultParser.parse(results, twitter_search_result, nil)
      twitter_search_result.update(completed: true)
    rescue StandardError => e
      Honeybadger.notify(e)
    end
  end
end
