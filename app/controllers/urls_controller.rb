class UrlsController < FilteredListController
  include ActionView::RecordIdentifier

  def index
    @topic = Topic.find_by(id: params[:topic_id])

    begin
      @pagy, @urls = pagy(@topic.unedited_urls(params[:sort], params[:time_filter]))
    rescue Pagy::OverflowError
      params[:page] = 1
      @pagy, @urls = pagy(@topic.unedited_urls(params[:sort], params[:time_filter]))
    end
  end

  def update
    @topic = Topic.find_by(id: params[:topic_id])
    @url = Url.includes(:tweet).find_by(id: params[:id])
    @url.tweet&.update(url_params.except(:page, :topic_id))

    respond_to do |format|
      format.html { redirect_to topic_urls_url(@topic, page: url_params[:page], sort: @sort) }
      format.turbo_stream { render turbo_stream: turbo_stream.remove(dom_id(@url)) }
    end
  end

  def url_params
    params.require(:url).permit(:saved, :archived, :page, :topic_id, )
  end
end
