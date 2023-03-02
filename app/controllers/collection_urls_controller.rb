class CollectionUrlsController < ApplicationController
  def update
    @collection = current_user.collections.find(params[:collection_id])
    @url = @collection.topic.urls.find(params[:id])

    @url.update(url_params)

    redirect_to(collection_path(@collection))
  end

  def url_params
    params.require(:url).permit(:editorial_title, :editorial_url, :editorial_description)
  end
end
