class TweetsController < AuthenticatedUserController
  include ActionView::RecordIdentifier
  before_action :determine_sort

  def index
    @topic = Topic.where(id: params[:topic_id]).includes(:search_terms, :negative_search_terms).first
    @pagy, @tweets = pagy(params[:sort] == 'newest' ? @topic.newest_unedited_tweets : @topic.unedited_tweets)
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
    params.require(:tweet).permit(:ignored, :saved, :archived, :page)
  end

  def determine_sort
    return 'score' unless params[:sort].present?
    return 'score' unless params[:sort].in? %w[score newest]

    params[:sort]
  end
end
