class TwitterSearchResultsController < ApplicationController

  def index
    @topic = Topic.find_by(id: params[:topic_id])
    @twitter_search_results = @topic.twitter_search_results.newest.limit(30)
  end

  def create
    @topic = Topic.find_by(id: params[:topic_id])

    unless @topic.search_in_progress?
      @topic.twitter_search_results.create(manual_search: true, limited: true, max_results: 1000)
    end

    redirect_to topic_twitter_search_results_url(@topic)
  end
end
