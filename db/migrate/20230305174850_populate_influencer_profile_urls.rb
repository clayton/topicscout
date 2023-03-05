class PopulateInfluencerProfileUrls < ActiveRecord::Migration[7.0]
  def change
    Influencer.where(profile_image_url: nil).in_batches do |batch|
      batch.each do |influencer|
        influencer.update!(profile_image_url: "https://twitter.com/#{influencer.username}")
      end
    end
  end
end
