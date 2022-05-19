class CreateTwitterSearchResults < ActiveRecord::Migration[7.0]
  def change
    create_table :twitter_search_results, id: :uuid do |t|
      t.references :topic, null: false, foreign_key: true, type: :uuid
      t.string :newest_tweet_id
      t.string :oldest_tweet_id
      t.integer :tweets_count, default: 0
      t.integer :max_results, default: 10
      t.boolean :completed, default: false
      t.datetime :start_time

      t.timestamps
    end
  end
end
