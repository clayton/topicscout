class TweetsController < AuthenticatedUserController
  include ActionView::RecordIdentifier
  before_action :determine_sort

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

  def determine_sort
    return 'score' unless params[:sort].present?
    return 'score' unless params[:sort].in? %w[score newest]

    params[:sort]
  end

  def determine_time_filter
    return 'all' unless params[:time_filter].present?
    return 'all' unless params[:time_filter].in? %w[all hour day week]

    params[:time_filter]
  end
end
