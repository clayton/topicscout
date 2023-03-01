class ChangeMaxResultsDefaultOnTwitterSearchResults < ActiveRecord::Migration[7.0]
  def change
    change_column_default :twitter_search_results, :max_results, 1000
  end
end
