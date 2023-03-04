class TweetsController < FilteredListController
  include ActionView::RecordIdentifier
  
  def index

    @topic = Topic.where(id: permitted_params[:topic_id]).includes(:search_terms, :negative_search_terms).first

    begin
      @pagy, @tweets = pagy(@topic.unedited_tweets(permitted_params[:sort], permitted_params[:time_filter], permitted_params[:visibility_filter]))
    rescue Pagy::OverflowError
      permitted_params[:page] = 1
      @pagy, @tweets = pagy(@topic.unedited_tweets(permitted_params[:sort], permitted_params[:time_filter], permitted_params[:visibility_filter]))
    end
  end

  def update
    @topic = Topic.find_by(id: permitted_params[:topic_id])
    @tweet = @topic.tweets.find_by(id: permitted_params[:id])
    @tweet.update!(tweet_params.except(:page))

    respond_to do |format|
      format.html { redirect_to topic_tweets_url(@topic, page: filter_params[:page], sort: determine_sort) }
      format.turbo_stream { render turbo_stream: turbo_stream.remove(dom_id(@tweet, 'listed')) }
    end
  end

  def permitted_params
    params.permit(:page, :sort, :time_filter, :visibility_filter, :topic_id)
  end

  def tweet_params
    params.require(:tweet).permit(:ignored, :saved, :archived, :topic_id)
  end
end
