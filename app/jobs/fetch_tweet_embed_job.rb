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

    begin
      results = conn.get('/oembed', url: url, hide_media: true, hide_thread: true, omit_script: true)

      return if results.nil?
      return if results.body.nil?
      # return if results.body.include?(%(<html lang="en" class="dog">))
      return if results.body['html'].blank?

      massaged = results.body['html'].gsub!(%r{</?blockquote}, '<p')

      tweet.update(embed_html: massaged, embed_cache_expires_at: Time.at(results.body['cache_age'].to_i))
    rescue StandardError => e
      Honeybadger.notify("FetchTweetEmbedJob (#{tweet&.id}): #{e.message}")
    end
  end
end
