class TwitterListSearchJob < ApplicationJob
  queue_as :default

  def perform(twitter_search_result, list, token)
    return unless token
    return unless list
    return unless twitter_search_result

    body = { 'tweet.fields' => 'created_at,entities,lang,public_metrics', 'expansions' => 'author_id',
             'user.fields' => 'username,profile_image_url,public_metrics,verified,verified_type' }
    headers = { 'Authorization' => "Bearer #{token}" }

    url = "https://api.twitter.com/2/lists/#{list.twitter_list_id}/tweets"

    results = Faraday.get(url, body, headers)

    unless results.success?
      Rails.logger.debug("[TwitterListSearchJob] for list #{list.twitter_list_id} failed with #{results.body}")
      Honeybadger.notify("[TwitterListSearchJob] for list #{list.twitter_list_id} failed with #{results.body}")
      return
    end

    data = JSON.parse(results.body)

    Rails.logger.info("[TwitterListSearchJob] List: #{url} \n options: #{body}\n\n")

    TwitterListSearchResultParser.parse(data, twitter_search_result, list, nil)
    
  rescue StandardError => e
    Rails.logger.debug("[TwitterSearchJob] #{e.message} #{e.backtrace}}")
    Honeybadger.notify(e)
  end
end
