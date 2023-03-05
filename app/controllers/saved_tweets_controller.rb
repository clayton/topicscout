class SavedTweetsController < ApplicationController
  include ActionView::RecordIdentifier
  
  def update
    @topic = Topic.find(params[:topic_id])
    @tweet = @topic.tweets.find(params[:id])
    @tweet.update(saved: true)

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(dom_id(@tweet)) }
    end
  end
end
