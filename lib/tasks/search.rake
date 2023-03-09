namespace :search do
  desc 'Search twitter'
  task twitter: :environment do
    Topic.active.all.each do |topic|
      next if topic.search_in_progress?

      topic.twitter_search_results.create(max_results: 3000, limited: true)
    end
  end

  task lists: :environment do
    Topic.active.all.each do |topic|
      topic.twitter_search_results.create(max_results: 3000, limited: true, list_search: true)
    end
  end
end
