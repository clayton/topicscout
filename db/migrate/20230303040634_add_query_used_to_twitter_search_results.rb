class AddQueryUsedToTwitterSearchResults < ActiveRecord::Migration[7.0]
  def change
    add_column :twitter_search_results, :query, :text
    change_column_default :twitter_search_results, :errored, false
  end
end
