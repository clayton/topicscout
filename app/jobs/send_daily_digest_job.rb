require 'postmark'

class SendDailyDigestJob < ApplicationJob
  include Routeable

  queue_as :default

  def perform(twitter_search_result = nil)
    return unless twitter_search_result
    return unless twitter_search_result.completed?

    topic = twitter_search_result.topic
    user = topic&.user

    return unless user

    client = Postmark::ApiClient.new(Rails.application.credentials.postmark_api_token)

    # Example request
    client.deliver_with_template(
      { from: 'help@topicscout.app',
        to: user.email,
        template_alias: 'daily-tweet-digest',
        template_model: twitter_search_result.digest }
    )
  rescue StandardError => e
    Honeybadger.notify(e)
  end
end
