class DeleteTopicJob < ApplicationJob
  queue_as :default

  def perform(topic)
    topic.tweets.in_batches(of: 1000) do |tweets|
      tweets.destroy_all
    end

    topic.urls.in_batches(of: 1000) do |urls|
      urls.destroy_all
    end

    topic.destroy
  end
end
