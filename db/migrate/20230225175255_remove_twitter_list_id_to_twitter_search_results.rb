class RemoveTwitterListIdToTwitterSearchResults < ActiveRecord::Migration[7.0]
  def change
    remove_column :twitter_search_results, :twitter_list_id
  end
end
