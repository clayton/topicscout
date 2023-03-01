class AddSearchMetricsToTwitterSearchResults < ActiveRecord::Migration[7.0]
  def change
    add_column :twitter_search_results, :ignored_count, :integer, default: 0
    add_column :twitter_search_results, :added_count, :integer, default: 0
  end
end
