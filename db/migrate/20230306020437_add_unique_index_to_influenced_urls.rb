class AddUniqueIndexToInfluencedUrls < ActiveRecord::Migration[7.0]
  def change
    add_index :tweeted_urls, %i[tweet_id url_id], unique: true
    add_index :influenced_urls, %i[url_id influencer_id], unique: true
  end
end
