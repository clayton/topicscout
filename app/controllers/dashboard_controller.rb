class DashboardController < AuthenticatedUserController
  def show
    @tweets_in_30_days = current_user.topics.map(&:tweets).flatten.select { |t| t.created_at > 30.days.ago }.size
    @twitter_search_results_in_30_days = current_user.topics.map(&:twitter_search_results).flatten.select { |t| t.created_at > 30.days.ago }.size
    @ignored_tweets_in_30_days = current_user.topics.map(&:tweets).flatten.select { |t| t.created_at > 30.days.ago && t.ignored? }.size
  end
end
