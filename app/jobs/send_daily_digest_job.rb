require 'postmark'

class SendDailyDigestJob < ApplicationJob
  include Routeable
  
  queue_as :default

  def perform(twitter_search_result=nil)
    return unless twitter_search_result
    return unless twitter_search_result.completed?

    Rails.logger.debug('-------------- SendDailyDigestJob --------------')
    
    topic = twitter_search_result.topic
    user = topic&.user

    Rails.logger.debug("topic: #{topic.name}")
    Rails.logger.debug("user: #{user.name}")

    return unless user

    client = Postmark::ApiClient.new(Rails.application.credentials.postmark_api_token)

    # Example request
    client.deliver_with_template(
      { from: 'help@topicscout.app',
        to: user.email,
        template_alias: 'daily-tweet-digest',
        template_model: twitter_search_result.digest }
    )
  end
end
