class TweetReadReceiptsController < ApplicationController
  before_action :load_topic

  def create
  end

  private

  def load_topic
    @topic = Topic.find(params[:topic_id])
  end

  def tweet_read_receipt_params
    params.permit(:tweets)
  end

end
