class TwitterListMembershipsController < AuthenticatedUserController
  def create
    @topic = Topic.find(params[:topic_id])
    @tweet = @topic.tweets.find(params[:tweet_id])

    @tweet.add_to_twitter_list
  end
end
