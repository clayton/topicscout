class DashboardController < AuthenticatedUserController
  before_action :check_for_new_user

  def show
    # @tweets_in_30_days = current_user.topics.map(&:tweets).flatten.select { |t| t.created_at > 30.days.ago }.size
    # @twitter_search_results_in_30_days = current_user.topics.map(&:twitter_search_results).flatten.select { |t| t.created_at > 30.days.ago }.size
    # @ignored_tweets_in_30_days = current_user.topics.map(&:tweets).flatten.select { |t| t.created_at > 30.days.ago && t.ignored? }.size
    # @topics = current_user.topics.order(:name)
  end
end
