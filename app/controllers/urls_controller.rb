class UrlsController < AuthenticatedUserController
  def index
    @topic = Topic.find_by(id: params[:topic_id])
    @pagy, @urls = pagy(@topic.unedited_urls)
  end

  def update
    @topic = Topic.find_by(id: params[:topic_id])
    @url = Url.includes(:tweet).find_by(id: params[:id])

    @url.tweet.update(url_params)
    redirect_to topic_urls_path(@topic)
  end

  def url_params
    params.require(:url).permit(:saved, :archived)
  end
end
