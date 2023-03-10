class UrlsController < FilteredListController
  def index
    @topic = Topic.find_by(id: params[:topic_id])

    begin
      @pagy, @urls = pagy(@topic.unedited_urls(permitted_params[:sort], permitted_params[:time_filter],
                                               permitted_params[:visibility_filter], permitted_params[:influencers_filter]))
    rescue Pagy::OverflowError
      params[:page] = 1
      @pagy, @urls = pagy(@topic.unedited_urls(permitted_params[:sort], permitted_params[:time_filter],
                                               permitted_params[:visibility_filter], permitted_params[:influencers_filter]))
    end
  end

  def show
    @url = Url.includes(:influencers, :topic, :tweets).where(id: params[:id]).first
    @topic = @url.topic
    @influencers = @url.influencers
    @tweets = @url.tweets
  end

  def permitted_params
    params.permit(:page, :sort, :time_filter, :visibility_filter, :topic_id, :id, :influencers_filter)
  end
end
