class AddTweetMetricsToUrls < ActiveRecord::Migration[7.0]
  def change
    add_column :urls, :like_count, :integer, default: 0
    add_column :urls, :retweet_count, :integer, default: 0
    add_column :urls, :impression_count, :integer, default: 0
  end
end
