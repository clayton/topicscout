class UrlsController < AuthenticatedUserController
  def index
    @topic = Topic.find_by(id: params[:topic_id])
    @pagy, @urls = pagy(@topic.unedited_urls)
  end

  def update
    @topic = Topic.find_by(id: params[:topic_id])
    @url = Url.includes(:tweet).find_by(id: params[:id])

    @url.tweet.update(saved: true)
    redirect_to topic_urls_path(@topic)
  end
end
