module UrlsHelper
  def url_bg_color(url)
    return 'bg-sky-50' if url&.first_influencer&.collected_tweets
    return 'bg-yellow-50' if url&.first_influencer&.saved_tweets

    'bg-white'
  end
end
