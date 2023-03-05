class CreateTweetedUrls < ActiveRecord::Migration[7.0]
  def change
    create_table :tweeted_urls, id: :uuid do |t|
      t.uuid :tweet_id
      t.uuid :url_id

      t.timestamps
    end
  end
end
