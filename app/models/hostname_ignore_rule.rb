class HostnameIgnoreRule < ApplicationRecord
  belongs_to :topic

  after_create_commit :archive_tweets

  def archive_tweets
    urls = topic.urls.includes(:tweet).unedited.uncollected.where(['unwound_url LIKE ?', "%#{hostname}%"])
    urls.each do |url|
      url.tweet.update(archived: true)
    end
  end
end
