class ArchivedTweetsController < ApplicationController
  def create
    @topic = Topic.find(params[:topic_id])
    permitted = params.permit(:sort, :time_filter)
    @topic.unedited_tweets(permitted[:sort], permitted[:time_filter]).update_all(archived: true)

    redirect_to topic_tweets_path(@topic)
  end
end
