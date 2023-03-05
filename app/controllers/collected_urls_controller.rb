class CollectedUrlsController < ApplicationController
  def update
    @collection = Collection.find(params[:collection_id])
    @url = Url.find(params[:id])

    @url.update(collection_id: @collection.id)

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@url) }
    end
  end
end
