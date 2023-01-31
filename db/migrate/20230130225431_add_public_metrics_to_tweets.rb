class AddPublicMetricsToTweets < ActiveRecord::Migration[7.0]
  def change
    add_column :tweets, :retweet_count, :integer, default: 0
    add_column :tweets, :reply_count, :integer, default: 0
    add_column :tweets, :like_count, :integer, default: 0
    add_column :tweets, :quote_count, :integer, default: 0
    add_column :tweets, :impression_count, :integer, default: 0
  end
end
