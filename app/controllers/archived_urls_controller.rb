class ArchivedUrlsController < AuthenticatedUserController
  def create
    @topic = Topic.find(params[:topic_id])
    permitted = params.permit(:sort, :time_filter)

    @topic.unedited_urls(permitted[:sort], permitted[:time_filter]).each do |url|
      url.tweet.update(archived: true)
    end

    redirect_to topic_urls_path(@topic)
  end
end
