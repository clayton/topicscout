class TweetsController < FilteredListController
  include ActionView::RecordIdentifier
  
  def index
    @topic = Topic.where(id: params[:topic_id]).includes(:search_terms, :negative_search_terms).first

    begin
      @pagy, @tweets = pagy(@topic.unedited_tweets(params[:sort], params[:time_filter]))
    rescue Pagy::OverflowError
      params[:page] = 1
      @pagy, @tweets = pagy(@topic.unedited_tweets(params[:sort], params[:time_filter]))
    end
  end

  def update
    @topic = Topic.find_by(id: params[:topic_id])
    @tweet = @topic.tweets.find_by(id: params[:id])
    @tweet.update!(tweet_params.except(:page))

    respond_to do |format|
      format.html { redirect_to topic_tweets_url(@topic, page: tweet_params[:page], sort: determine_sort) }
      format.turbo_stream { render turbo_stream: turbo_stream.remove(dom_id(@tweet, 'listed')) }
    end
  end

  def tweet_params
    params.require(:tweet).permit(:ignored, :saved, :archived, :page, :topic_id)
  end
end
