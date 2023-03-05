class AddInfluencerIdToTweets < ActiveRecord::Migration[7.0]
  def change
    add_column :tweets, :influencer_id, :uuid
    add_index :tweets, :influencer_id
  end
end
