class AddPublishedAtFields < ActiveRecord::Migration[7.0]
  def change
    add_column :tweets, :published_at, :datetime
    add_column :urls, :published_at, :datetime

    Tweet.all.in_batches(of: 1000) do |batch|
      batch.each do |tweet|
        tweet.update(published_at: tweet.tweeted_at)

        tweet.urls.each do |url|
          url.update(published_at: tweet.tweeted_at)
        end
      end
    end
  end
end
