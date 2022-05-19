class TweetsController < ApplicationController
  def index
    @topic = Topic.find_by(id: params[:topic_id])
    @twitter_search_result = @topic.twitter_search_results.new
    @pagy, @tweets = pagy(@topic.tweets.newest)
  end
end
