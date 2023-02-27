class HostnameIgnoreRulesController < ApplicationController
  include ActionView::RecordIdentifier
  
  def create
    @topic = Topic.includes(:tweets).find(params[:topic_id])
    @tweet = @topic.tweets.includes(:urls).find_by(id: rule_params[:tweet_id])
    @url = @tweet.urls.find_by(id: rule_params[:url_id])

    @topic.hostname_ignore_rules.create(hostname: rule_params[:hostname])
    
    @tweet.update(ignored: true, archived: true)

    respond_to do |format|
      format.html { redirect_to topic_urls_url(@topic) }
      format.turbo_stream { render turbo_stream: turbo_stream.remove(dom_id(@url)) }
    end
  end

  def rule_params
    params.require(:hostname_ignore_rule).permit(:hostname, :topic_id, :url_id, :tweet_id)
  end
end