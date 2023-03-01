class TopicsController < AuthenticatedUserController
  before_action :check_for_new_user

  def index
    @topics = current_user.topics.order(:name)
  end

  def new
    @topic = Topic.new
    @topic.twitter_lists.build
    3.times { @topic.search_terms.build }
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
    @topic.twitter_lists.build
    3.times { @topic.search_terms.build }
  end

  def show
    @topic = Topic.find(params[:id])
    @pagy, @tweets = pagy(@topic.tweets.newest)
  end

  def update
    @topic = Topic.find_by(id: params[:id])
    @topic.update(topic_params)

    flash[:success] = 'Your topic has been updated.'

    redirect_to edit_topic_url(@topic)
  end

  def destroy
    @topic = Topic.find_by(id: params[:id])

    if params[:delete] && params[:delete] == '1'
      @topic.destroy
      flash[:success] = 'Your topic has been deleted.'

      redirect_to root_url
    else
      redirect_to edit_topic_url(@topic)
    end
  end

  private

  def topic_params
    params.require(:topic).permit(:topic, :require_links, :require_media, :require_images, :ignore_ads, :require_verified, :daily_digest, :filter_by_language, :threshold, :weekly_digest, :search_time_zone, :search_time_hour, :name, search_term: %i[term required exact_match],
                                                                                                                                                                                                                                        search_terms_attributes: %i[term id required exact_match],
                                                                                                                                                                                                                                        new_search_terms: %i[term required exact_match],
                                                                                                                                                                                                                                        negative_search_term: [:term],
                                                                                                                                                                                                                                        negative_search_terms_attributes: %i[term id],
                                                                                                                                                                                                                                        new_negative_search_terms: [],
                                                                                                                                                                                                                                        twitter_lists_attributes: %i[id name twitter_list_id _destroy])
  end
end
