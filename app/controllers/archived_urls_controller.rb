class ArchivedUrlsController < AuthenticatedUserController
  include ActionView::RecordIdentifier

  def create
    @topic = Topic.find(params[:topic_id])
    permitted_params = params.permit(:page, :sort, :time_filter, :visibility_filter, :topic_id)
    @urls = @topic.unedited_urls(permitted_params[:sort], permitted_params[:time_filter],
                                     permitted_params[:visibility_filter])

    @urls.update_all(archived: true)

    redirect_to topic_urls_path(@topic)
  end
  
  def update
    @topic = Topic.find(params[:topic_id])
    @url = @topic.urls.find(params[:id])
    @url.update(archived: true)

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(dom_id(@url)) }
    end
  end
end
