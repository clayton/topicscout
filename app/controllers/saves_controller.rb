class SavesController < FilteredListController
  before_action :load_topic
  before_action :load_collection

  def index
    begin
      @pagy, @tweets = pagy(@topic.saved_tweets(saves_params[:sort], saves_params[:time_filter]))
    rescue Pagy::OverflowError
      saves_params[:page] = 1
      @pagy, @tweets = pagy(@topic.saved_tweets(saves_params[:sort], saves_params[:time_filter]))
    end
    
  end

  def load_topic
    @topic = Topic.where(id: saves_params[:topic_id]).includes(:search_terms, :negative_search_terms).first
  end

  def load_collection
    @collection = @topic.collections.newest.first

    return if @collection.present?

    @collection = @topic.collections.create!(user: @topic.user,
                                             name: "#{@topic.name} Collection #{Time.current.strftime('%Y-%m-%d %H:%M:%S')}")
  end

  def saves_params
    params.permit(:sort, :time_filter, :page, :topic_id)
  end
end
