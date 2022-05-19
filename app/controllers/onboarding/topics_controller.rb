class Onboarding::TopicsController < ApplicationController
  layout 'onboarding'

  before_action :load_topic, only: [:show, :edit, :update]

  def show
  end  

  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.create(topic: topic_params[:topic])

    redirect_to onboarding_refine_url(@topic)
  end

  def edit
    @recent_tweets = @topic.tweets.recent
  end

  def update
    @topic = Topic.find_by(params[:topic_id])
    @topic.update(topic_params)

    redirect_to onboarding_finish_path(@topic)
  end

  private

  def load_topic
    @topic = Topic.find_by(id: params[:topic_id]) || Topic.find_by(id: params[:id])
  end

  def topic_params
    params.require(:topic).permit(:topic, search_term_attributes: [])
  end
end
