class ArchivedUrlsController < AuthenticatedUserController
  def create
    @topic = Topic.find(params[:topic_id])
    @topic.unedited_urls.each do |url|
      url.tweet.update(archived: true)
    end

    redirect_to topic_urls_path(@topic)
  end
end
