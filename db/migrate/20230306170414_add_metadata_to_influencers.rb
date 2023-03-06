class AddMetadataToInfluencers < ActiveRecord::Migration[7.0]
  def change
    add_column :influencers, :verified, :boolean, default: false
    add_column :influencers, :verified_type, :string
    add_column :influencers, :followers_count, :bigint, default: 0
    add_column :influencers, :following_count, :bigint, default: 0
    add_column :influencers, :tweet_count, :bigint, default: 0
    add_column :influencers, :listed_count, :bigint, default: 0
  end
end
