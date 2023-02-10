class ArchivedTweetsController < ApplicationController
  def create
    @topic = Topic.find(params[:topic_id])
    @topic.unedited_tweets.update_all(archived: true)

    redirect_to topic_tweets_path(@topic)
  end
end
