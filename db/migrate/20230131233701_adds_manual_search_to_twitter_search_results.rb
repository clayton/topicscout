class AddsManualSearchToTwitterSearchResults < ActiveRecord::Migration[7.0]
  def change
    add_column :twitter_search_results, :manual_search, :boolean, default: false
  end
end
