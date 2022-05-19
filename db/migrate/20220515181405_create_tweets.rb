class CreateTweets < ActiveRecord::Migration[7.0]
  def change
    create_table :tweets, id: :uuid do |t|
      t.references :twitter_search_result, null: false, foreign_key: true, type: :uuid
      t.references :topic, null: false, foreign_key: true, type: :uuid
      t.string :username
      t.string :name
      t.string :profile_image_url
      t.text :text
      t.string :tweet_id, index: true
      t.string :author_id
      t.string :intent
      t.datetime :tweeted_at
      t.text :embed_html
      t.datetime :embed_cache_expires_at

      t.timestamps
    end
  end
end
