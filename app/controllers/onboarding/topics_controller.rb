class Onboarding::TopicsController < AuthenticatedUserController
  layout 'onboarding'

  before_action :create_user, only: [:new]
  before_action :load_topic, only: %i[show edit update]

  def new
    Rails.logger.debug("Subscription: #{session[:subscription_id]}")
    @topic = Topic.new
    @placeholders = [
      'weeknight cooking',
      '#3dprinting',
      'crossfit workouts',
      'ruby on rails',
      '#CyberSecurity',
      'writing online'
    ]
  end

  def create
    @topic = Topic.new(name: topic_params[:topic], topic: topic_params[:topic], user: current_user)

    if @topic.save
      redirect_to onboarding_refine_url(@topic)
    else
      redirect_to onboarding_start_url
    end
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

  def create_user
    return if current_user

    @user = User.create
    session[:user_id] = @user.id
  end

  def load_topic
    @topic = Topic.find_by(id: params[:topic_id]) || Topic.find_by(id: params[:id])
  end

  def topic_params
    params.require(:topic).permit(:topic, new_search_terms: [])
  end
end
