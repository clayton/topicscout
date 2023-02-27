class UrlsController < AuthenticatedUserController
  include ActionView::RecordIdentifier

  before_action :determine_sort

  def index
    @topic = Topic.find_by(id: params[:topic_id])
    @pagy, @urls = pagy(@topic.unedited_urls(params[:sort], params[:time_filter]))
  end

  def update
    @topic = Topic.find_by(id: params[:topic_id])
    @url = Url.includes(:tweet).find_by(id: params[:id])
    @url.tweet&.update(url_params.except(:page, :topic_id))

    respond_to do |format|
      format.html { redirect_to topic_urls_url(@topic, page: tweet_params[:page], sort: determine_sort) }
      format.turbo_stream { render turbo_stream: turbo_stream.remove(dom_id(@url)) }
    end
  end

  def url_params
    params.require(:url).permit(:saved, :archived, :page, :topic_id)
  end

  protected

  def determine_sort
    return 'score' unless params[:sort].present?
    return 'score' unless params[:sort].in? %w[score newest]

    params[:sort]
  end

  def determine_time_filter
    return 'all' unless params[:time_filter].present?
    return 'all' unless params[:time_filter].in? %w[all hour day week]

    params[:time_filter]
  end
end
