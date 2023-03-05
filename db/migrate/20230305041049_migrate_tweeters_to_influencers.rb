class MigrateTweetersToInfluencers < ActiveRecord::Migration[7.0]
  def change
    Tweet.all.in_batches(of: 1000) do |batch|
      batch.each do |tweet|
        influencer = Influencer.find_or_create_by!(platform_id: tweet.author_id) do |i|
          i.name = tweet.name
          i.profile_image_url = tweet.profile_image_url
          i.username = tweet.username
          i.platform = 'twitter'
          i.topic = tweet.topic
        end

        tweet.update!(influencer_id: influencer.id)

        tweet.urls.each do |url|
          influencer.influenced_urls.create(url: url)
        end
      end
    end
  end
end
