class SavesController < AuthenticatedUserController
  before_action :load_topic
  before_action :load_collection

  def index
    @pagy, @tweets = pagy(@topic.tweets.reviewing.uncollected.best.includes(:hashtags,
                                                                            :urls).where.not(urls: { title: nil,
                                                                                                     url: nil }))
  end

  def load_topic
    @topic = Topic.where(id: params[:topic_id]).includes(:search_terms, :negative_search_terms).first
  end

  def load_collection
    @collection = @topic.collections.newest.first

    return if @collection.present?

    @collection = @topic.collections.create!(user: @topic.user,
                                             name: "#{@topic.name} Collection #{Time.current.strftime('%Y-%m-%d %H:%M:%S')}")
  end
end
