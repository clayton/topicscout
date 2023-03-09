class HostnameIgnoreRule < ApplicationRecord
  belongs_to :topic

  after_create_commit :archive_tweets

  def archive_tweets
    urls = topic.urls.includes(:tweets).unedited.uncollected.where(['unwound_url LIKE ?', "%#{hostname}%"])
    urls.each do |url|
      url.update(ignored: true)
      url.tweets.update_all(ignored: true)
    end
  end
end
