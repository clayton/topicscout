class CollectedTweetsController < AuthenticatedUserController
  def update
    @collection = Collection.find(params[:collection_id])
    @tweet = Tweet.find(params[:id])

    @tweet.update(collection_id: @collection.id)

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@tweet) }
    end
  end
end
