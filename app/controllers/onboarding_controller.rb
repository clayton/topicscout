class OnboardingController < ApplicationController
  before_action :set_topic

  def start
    reset_session
  end

  def refine
    session[:topic] = onboarding_params[:topic].downcase.strip if onboarding_params[:topic]
    @recent_tweets = @topic.tweets.order(created_at: :desc).limit(10)
  end

  def review; end

  def finish; end

  def onboarding_params
    params.permit(:topic, :authenticity_token)
  end

  private

  def set_topic
    topic = onboarding_params[:topic].downcase.strip if onboarding_params[:topic]

    @topic = Topic.find_or_create_by(topic: topic) || Topic.find_by(id: session[:topic_id]) || Topic.find_or_create_by(topic: session[:topic])
    session[:topic_id] = @topic.id
  end
end
