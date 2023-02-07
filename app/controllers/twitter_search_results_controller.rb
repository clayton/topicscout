class TwitterSearchResultsController < ApplicationController

  def create
    @topic = Topic.find_by(id: params[:topic_id])
    @topic.twitter_search_results.create(manual_search: true)

    redirect_to topic_tweets_url(@topic)
  end
end
