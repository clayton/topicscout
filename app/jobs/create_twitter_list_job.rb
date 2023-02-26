class CreateTwitterListJob < ApplicationJob
  queue_as :priority

  def perform(name, description, token, topic_id)
    client = Faraday.new(url: 'https://api.twitter.com') do |f|
      f.adapter Faraday.default_adapter
      f.request :json
      f.response :json
      f.request :authorization, 'Bearer', token
    end

    body = {
      name: name,
      description: description,
      private: true
    }.to_json

    response = client.post('/2/lists', body, {})

    unless response.success?
      Rails.logger.debug("CreateTwitterListJob: #{response.body}")
      Honeybadger.notify("CreateTwitterListJob: #{response.body}")
      return
    end

    topic = Topic.find_by(id: topic_id)
    return if topic.nil?

    topic.twitter_lists.create(
      name: name,
      description: description,
      twitter_list_id: response.body['data']['id'],
      private: true
    )
    
  end
end
