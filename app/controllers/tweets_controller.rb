class TweetsController < AuthenticatedUserController
  def index
    @topic = Topic.find_by(id: params[:topic_id])
    @pagy, @tweets = pagy(@topic.tweets.relevant.newest)
  end
end
