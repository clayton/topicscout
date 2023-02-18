class SavesController < AuthenticatedUserController
  def index
    @topic = Topic.find_by(id: params[:topic_id])
    @collection = @topic.collections.newest.first

    @pagy, @tweets = pagy(@topic.tweets.reviewing.uncollected.best.includes(:hashtags, :urls).where.not(urls: { title: nil, url: nil }))
  end
end
