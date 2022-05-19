class Onboarding::InterestsController < ApplicationController

  layout 'onboarding'

  before_action :load_topic

  def new
    @interest = Interest.new(topic: @topic)
    @recent_tweets = @topic.tweets.newest.limit(3)
    session[:topic_id] = @topic.id
  end

  def load_topic
    @topic = Topic.find_by(id: params[:topic_id])
  end
end
