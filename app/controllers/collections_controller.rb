class CollectionsController < AuthenticatedUserController
  def index
    @collections = current_user.collections.all.order(created_at: :desc)
  end

  def show
    @collection = current_user.collections.includes(tweets: :urls).find(params[:id])
    @tweets = @collection.tweets.unarchived.order(score: :desc)
    @urls = @collection.urls.unarchived.order(score: :desc)
  end

  def new
    @collection = current_user.collections.new
  end

  def edit
    @collection = current_user.collections.find(params[:id])
  end

  def update
    @collection = current_user.collections.find(params[:id])
    @collection.update(collection_params)
    redirect_to collections_path
  end

  def create
    @collection = current_user.collections.new(collection_params)
    @collection.save
    redirect_to collections_path
  end

  def destroy
    @collection = current_user.collections.find(params[:id])
    @collection.destroy
    redirect_to collections_path
  end

  def collection_params
    params.require(:collection).permit(:name, :topic_id)
  end
end
