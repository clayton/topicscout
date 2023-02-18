class CollectionTweetsController < AuthenticatedUserController
  def update
    @collection = current_user.collections.find(params[:collection_id])
    @tweet = Tweet.find(params[:id])

    @tweet.update!(collection: @collection) if tweet_params[:saved] == 'true'

    @tweet.update!(archived: true, collection: nil) if tweet_params[:archived] == 'true'

    redirect_to topic_saves_path(@tweet.topic)
  end

  def tweet_params
    params.require(:tweet).permit(:collection_id, :archived, :saved)
  end
end
