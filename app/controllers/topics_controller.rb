class TopicsController < AuthenticatedUserController
  before_action :check_for_new_user

  def index
    @topics = current_user.topics
  end

  def new
    @topic = Topic.new
  end

  def create
    @topic = current_user.topics.build(topic_params)

    if @topic.save!
      flash[:success] = 'Your topic has been created.'
      redirect_to topic_tweets_url(@topic)
    else
      flash[:error] = 'There was an error creating your topic.'
      render :new
    end
  end

  def edit
    @topic = Topic.find(params[:id])
  end

  def show
    @topic = Topic.find(params[:id])
    @pagy, @tweets = pagy(@topic.tweets.newest)
  end

  def update
    @topic = Topic.find_by(params[:topic_id])
    @topic.update(topic_params)

    flash[:success] = 'Your topic has been updated.'

    redirect_to topic_tweets_path(@topic)
  end

  private

  def topic_params
    params.require(:topic).permit(:topic, :daily_digest, :weekly_digest, :name, search_term: [:term],
                                                                                search_terms_attributes: %i[term id],
                                                                                new_search_terms: [])
  end

  def check_for_new_user
    redirect_to onboarding_start_url if current_user.topics.empty?
  end
end
