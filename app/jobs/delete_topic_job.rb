class DeleteTopicJob < ApplicationJob
  queue_as :default

  def perform(topic)
    topic.tweets.in_batches(of: 100) do |tweets|
      tweets.destroy_all
    end

    topic.destroy
  end
end
