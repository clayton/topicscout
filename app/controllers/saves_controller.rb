class SavesController < AuthenticatedUserController
  def index
    @topic = Topic.find_by(id: params[:topic_id])
    @collection = @topic.collections.newest.first || @topic.collections.create(name: "#{@topic.name} Collection #{Time.current.strftime('%Y-%m-%d %H:%M:%S')}")

    @pagy, @tweets = pagy(@topic.tweets.reviewing.uncollected.best.includes(:hashtags,
                                                                            :urls).where.not(urls: { title: nil,
                                                                                                     url: nil }))
  end
end
