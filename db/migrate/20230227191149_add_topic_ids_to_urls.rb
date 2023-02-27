class AddTopicIdsToUrls < ActiveRecord::Migration[7.0]
  def change
    Url.where(topic_id: nil).find_each do |url|
      url.update(topic_id: url.tweet.topic_id) if url.tweet
    end
  end
end
