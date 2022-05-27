require 'faraday'
require 'faraday/net_http'
Faraday.default_adapter = :net_http

class FetchTweetEmbedJob < ApplicationJob
  queue_as :default

  def perform(tweet)
    url = tweet.url

    conn = Faraday.new('https://publish.twitter.com') do |f|
      f.request :url_encoded
      f.request :retry
      f.response :json
      f.adapter :net_http
      f.request :authorization, 'Bearer', ENV.fetch('TWITTER_BEARER_TOKEN', nil)
    end

    results = conn.get('/oembed', url: url, hide_media: true, hide_thread: true, omit_script: true)

    return if results.nil?
    return if results.body.nil?
    return if results.body['html'].blank?

    tweet.update(embed_html: results.body['html'], embed_cache_expires_at: Time.at(results.body['cache_age'].to_i))
  end
end
