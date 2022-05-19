class TwitterSearchResultsController < ApplicationController
  def create
    @topic = Topic.find_by(params[:topic_Id])
    @topic.twitter_search_results.create

    redirect_to topic_tweets_url(@topic)
  end
end
