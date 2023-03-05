class InfluencerIgnoreRulesController < AuthenticatedUserController
  before_action :load_topic

  def create
    @topic.tweeter_ignore_rules.create(author_id: permitted_params[:author_id])

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(permitted_params[:remove_id]) }
    end
  end

  def load_topic
    @topic = Topic.find_by(id: params[:topic_id])
  end

  def permitted_params
    params.permit(:author_id, :topic_id, :remove_id)
  end
end
