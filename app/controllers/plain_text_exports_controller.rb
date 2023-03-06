class PlainTextExportsController < AuthenticatedUserController
  def show
    @collection = current_user.collections.includes(tweets: :urls).find(params[:id])
    @tweets = @collection.tweets.order(score: :desc)
    @urls = @collection.urls.order(score: :desc)
  end
end
