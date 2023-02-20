class AddExtraSearchOperatorsToTopics < ActiveRecord::Migration[7.0]
  def change
    add_column :topics, :require_links, :boolean
    add_column :topics, :require_images, :boolean
    add_column :topics, :require_media, :boolean
    add_column :topics, :ignore_ads, :boolean
    add_column :topics, :require_verified, :boolean
  end
end
