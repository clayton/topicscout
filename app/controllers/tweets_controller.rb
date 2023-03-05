class TweetsController < FilteredListController
  def index
    @topic = Topic.where(id: permitted_params[:topic_id]).includes(:search_terms, :negative_search_terms).first

    begin
      @pagy, @tweets = pagy(@topic.unedited_tweets(permitted_params[:sort], permitted_params[:time_filter],
                                                   permitted_params[:visibility_filter]))
    rescue Pagy::OverflowError
      params[:page] = 1
      @pagy, @tweets = pagy(@topic.unedited_tweets(permitted_params[:sort], permitted_params[:time_filter],
                                                   permitted_params[:visibility_filter]))
    end
  end

  def permitted_params
    params.permit(:page, :sort, :time_filter, :visibility_filter, :topic_id)
  end
end
