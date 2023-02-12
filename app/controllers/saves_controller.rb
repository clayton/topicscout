class SavesController < AuthenticatedUserController
  def index
    @topic = Topic.find_by(id: params[:topic_id])

    @pagy, @tweets = pagy(@topic.tweets.reviewing.best.includes(:hashtags, :urls).where.not(urls: { title: nil, url: nil }))
  end
end
