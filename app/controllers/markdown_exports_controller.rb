class MarkdownExportsController < ApplicationController
  def show
    @collection = current_user.collections.includes(tweets: :urls).find(params[:id])
    @tweets = @collection.tweets.unarchived.order(score: :desc)
    @urls = @collection.urls.unarchived.order(score: :desc)
  end
end
