namespace :search do
  desc 'Search twitter'
  task twitter: :environment do
    Topic.all.each do |topic|
      next if topic.search_in_progress?
      topic.twitter_search_results.create(max_results: 1000, limited: false)
    end
  end
end
