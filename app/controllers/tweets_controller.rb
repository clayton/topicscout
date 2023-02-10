class TweetsController < AuthenticatedUserController
  def index
    @topic = Topic.find_by(id: params[:topic_id])
    @pagy, @tweets = pagy(@topic.unedited_tweets)
  end

  def update
    @topic = Topic.find_by(id: params[:topic_id])
    @tweet = @topic.tweets.find_by(id: params[:id])
    @tweet.update(tweet_params)

    redirect_to topic_tweets_path(@topic)
  end

  def tweet_params
    params.require(:tweet).permit(:ignored, :saved, :archived)
  end
end
