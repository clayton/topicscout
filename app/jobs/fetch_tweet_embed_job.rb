require 'faraday'
require 'faraday/net_http'
Faraday.default_adapter = :net_http

class FetchTweetEmbedJob < ApplicationJob
  queue_as :default

  def perform(tweet)
    url = tweet.url

    conn = Faraday.new('https://publish.twitter.com/oembed') do |f|
      f.request :url_encoded
      f.request :retry
      f.response :json
      f.adapter :net_http
      f.request :authorization, 'Bearer', ENV.fetch('TWITTER_BEARER_TOKEN', nil)
    end

    conn.get(url, hide_media: true, hide_thread: true, omit_script: true)


  end
end
