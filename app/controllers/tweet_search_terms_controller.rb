class TweetSearchTermsController < AuthenticatedUserController
  def create
    @topic = Topic.find(params[:topic_id])
    @search_term = @topic.search_terms.find_or_create_by(search_term_params.except(:page))

    redirect_to topic_tweets_path(@topic, page: search_term_params[:page])
  end

  def search_term_params
    params.require(:search_term).permit(:term, :page)
  end
end
