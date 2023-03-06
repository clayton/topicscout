class TweeterIgnoreRule < ApplicationRecord
  belongs_to :topic

  after_create_commit :ignore_tweets

  def ignore_tweets
    influencer = Influencer.find_by(platform_id: author_id)

    return unless influencer

    influencer.tweets.uncollected.update_all(ignored: true)
    influencer.urls.uncollected.update_all(ignored: true)
  end
end
