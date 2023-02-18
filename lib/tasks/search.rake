namespace :search do
  desc 'Search twitter'
  task twitter: :environment do
    Topic.all.each do |topic|
      topic.twitter_search_results.create(max_results: 50, limited: true)
    end
  end
end
