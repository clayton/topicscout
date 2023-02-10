class AssociateOldEntitiesToTweets < ActiveRecord::Migration[7.0]
  def change
    UrlEntity.includes(:tweet).includes(:url).all.each do |entity|
      entity.url.update(tweet: entity.tweet)
    end

    HashtagEntity.includes(:tweet).includes(:hashtag).all.each do |entity|
      entity.hashtag.update(tweet: entity.tweet)
    end

    drop_table :url_entities
    drop_table :hashtag_entities
  end
end
