class Onboarding::UsersController < AuthenticatedUserController
  layout 'onboarding'

  before_action :load_topic

  def edit
    @user = current_user
    @recent_tweets = @topic.tweets.newest.limit(3)
  end

  def update
    @user = User.find_by(id: params[:id])
    @user.update(user_params)
    @verification = @user.email_verifications.pending.first

    respond_to do |format|
      format.html { redirect_to root_path }
      format.turbo_stream
    end
  end

  def load_topic
    @topic = current_user.topics.first
  end

  def user_params
    params.require(:user).permit(:email)
  end
end
