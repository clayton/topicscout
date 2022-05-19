class TopicsController < AuthenticatedUserController

  before_action :check_for_new_user

  def index
    @topics = current_user.topics
  end

  def show
    @topic = Topic.find(params[:id])
    @pagy, @tweets = pagy(@topic.tweets.newest)
  end

  def update
    @topic = Topic.find_by(params[:topic_id])
    @topic.update(topic_params)
  end

  private

  def topic_params
    params.require(:topic).permit(:topic)
  end

  def check_for_new_user
    redirect_to onboarding_start_url if current_user.topics.empty?
  end
end
