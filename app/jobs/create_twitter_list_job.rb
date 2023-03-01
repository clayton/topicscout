class CreateTwitterListJob < ApplicationJob
  queue_as :priority

  def perform(name, description, token, topic_id)

    client = Birder::Client.new(token)

    response = client.list.create(name, { description: description, private: true })

    topic = Topic.find_by(id: topic_id)
    return if topic.nil?

    topic.twitter_lists.create(
      name: name,
      description: description,
      twitter_list_id: response['data']['id'],
      private: true,
      managed: true
    )
  end
end
