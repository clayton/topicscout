class AddMissingTopicsToUrls < ActiveRecord::Migration[7.0]
  def change
    Url.where(topic_id: nil).in_batches do |batch|
      batch.each do |url|
        url.update!(topic_id: url.tweeted_urls.first&.tweet&.topic_id)
      end
    end
  end
end
