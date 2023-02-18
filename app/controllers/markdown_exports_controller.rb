class MarkdownExportsController < ApplicationController
  def show
    @collection = current_user.collections.includes(tweets: :urls).find(params[:id])
    @tweets = @collection.tweets.order(score: :desc)
    @urls = @tweets.map(&:urls).flatten.reject { |url| url.title.blank? }
  end
end
