class UrlsController < AuthenticatedUserController
  def index
    @topic = Topic.find_by(id: params[:topic_id])
    @pagy, @urls = pagy(@topic.urls
                              .joins(:tweets)
                              .where.not(title: nil)
                              .where(Tweet.arel_table[:score].gt(@topic.threshold))
                              .group('urls.id')
                              .order('sum(tweets.score) desc')
                              .limit(40))
  end
end
