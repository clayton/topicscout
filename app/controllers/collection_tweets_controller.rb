class CollectionTweetsController < AuthenticatedUserController
  include ActionView::RecordIdentifier

  def update
    @collection = current_user.collections.find(params[:collection_id])
    @tweet = Tweet.find(params[:id])

    @tweet.update!(collection: @collection) if tweet_params[:saved] == 'true'

    @tweet.update!(archived: true, collection: nil) if tweet_params[:archived] == 'true'

    

    respond_to do |format|
      format.html { redirect_to redirect_to topic_saves_path(@tweet.topic) }
      format.turbo_stream { render turbo_stream: turbo_stream.remove(dom_id(@tweet, 'saved')) }
    end
  end

  def tweet_params
    params.require(:tweet).permit(:collection_id, :archived, :saved)
  end
end
