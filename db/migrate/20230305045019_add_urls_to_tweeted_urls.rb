class AddUrlsToTweetedUrls < ActiveRecord::Migration[7.0]
  def change
    Url.all.in_batches(of: 1000) do |batch|
      batch.each do |url|
        TweetedUrl.create(url_id: url.id, tweet_id: url.tweet_id)
      end
    end
  end
end
