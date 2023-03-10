class SimilarUrlsController < ApplicationController
  def index
    @url = Url.find_by(id: params[:url_id])
    @similar = Url.includes(:influencers)
                  .relevant.unedited
                  .where.not(id: @url.id)
                  .search_by_title(@url.title)
                  .order(impression_count: :desc)
                  .limit(5)

    render template: 'similar_urls/index', layout: false
  end
end
