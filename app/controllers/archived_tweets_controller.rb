class ArchivedTweetsController < ApplicationController
  include ActionView::RecordIdentifier

  def create
    @topic = Topic.find(params[:topic_id])
    permitted_params = params.permit(:page, :sort, :time_filter, :visibility_filter, :topic_id)
    @tweets = @topic.unedited_tweets(permitted_params[:sort], permitted_params[:time_filter],
                                     permitted_params[:visibility_filter])

    @tweets.update_all(archived: true)

    redirect_to topic_tweets_path(@topic)
  end

  def update
    @topic = Topic.find(params[:topic_id])
    @tweet = @topic.tweets.find(params[:id])
    @tweet.update(archived: true)

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(dom_id(@tweet)) }
    end
  end
end
