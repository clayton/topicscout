namespace :search do
  desc 'Search twitter'
  task twitter: :environment do
    Topic.undeleted.all.each do |topic|
      next if topic.search_in_progress?
      
      topic.twitter_search_results.create(max_results: 3000, limited: true)
    end
  end
end
