class TweeterIgnoreRulesController < ApplicationController
  before_action :load_topic

  def create
    @topic.tweeter_ignore_rules.create(author_id: tweeter_ignore_rule_params[:author_id])
    @pagy, @tweets = pagy(@topic.tweets.relevant.newest)

    render 'tweets/index'
  end

  def tweeter_ignore_rule_params
    params.require(:tweeter_ignore_rule).permit(:author_id, :topic_id)
  end

  def load_topic
    @topic = Topic.find_by(id: params[:topic_id])
  end
end
