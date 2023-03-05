class CollectionUrlsController < AuthenticatedUserController
  def update
    @collection = current_user.collections.find(params[:collection_id])
    @url = @collection.topic.urls.find(params[:id])

    @url.update(url_params)

    respond_to do |format|
      format.html { redirect_to collection_path(@collection) }
      format.turbo_stream { render turbo_stream: turbo_stream.replace(@url, partial: 'collections/collected_url', locals: { collection: @collection, url: @url }) }
    end
  end

  def url_params
    params.require(:url).permit(:editorial_title, :editorial_url, :editorial_description, :editorial_category)
  end
end
