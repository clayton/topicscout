class SavedUrlsController < ApplicationController
  include ActionView::RecordIdentifier
  
  def update
    @topic = Topic.find(params[:topic_id])
    @url = @topic.urls.find(params[:id])
    @url.update(saved: true)

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(dom_id(@url)) }
    end
  end
end