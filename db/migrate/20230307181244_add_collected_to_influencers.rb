class AddCollectedToInfluencers < ActiveRecord::Migration[7.0]
  def change
    add_column :influencers, :collected_tweets, :boolean
    add_column :influencers, :saved_tweets, :boolean
  end
end
