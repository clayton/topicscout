class TweeterIgnoreRulesController < ApplicationController
  before_action :load_topic

  def create
    @topic.tweeter_ignore_rules.create(author_id: tweeter_ignore_rule_params[:author_id])
    @pagy, @tweets = pagy(@topic.tweets.relevant.newest)

    if tweeter_ignore_rule_params[:return_to] == 'urls'
      redirect_to topic_urls_url(@topic, page: tweeter_ignore_rule_params[:page] || 1)
    else
      redirect_to topic_tweets_url(@topic, page: tweeter_ignore_rule_params[:page] || 1)
    end
  end

  def tweeter_ignore_rule_params
    params.require(:tweeter_ignore_rule).permit(:author_id, :topic_id, :return_to, :page)
  end

  def load_topic
    @topic = Topic.find_by(id: params[:topic_id])
  end
end
