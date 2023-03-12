class TwitterListMembershipsController < AuthenticatedUserController
  include ActionView::RecordIdentifier

  def create
    @topic = Topic.find(params[:topic_id])
    @tweet = @topic.tweets.find(params[:tweet_id])

    @tweet.add_to_twitter_list

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(dom_id(@tweet.influencer, 'influencer_actions')) }
    end
  end
end
