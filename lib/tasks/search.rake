namespace :search do
  desc 'Search twitter'
  task twitter: :environment do
    current_hour = Time.now.in_time_zone('UTC').hour
    Topic.where(utc_search_hour: current_hour).each do |topic|
      topic.twitter_search_results.create(max_results: 100, limited: true)
    end
  end
end
