class NegativeSearchTermsController < AuthenticatedUserController
  def create
    @topic = Topic.find(params[:topic_id])
    @search_term = @topic.negative_search_terms.create(search_term_params)

    redirect_to topic_saves_path(@topic)
  end

  def search_term_params
    params.require(:negative_search_term).permit(:term)
  end
end
