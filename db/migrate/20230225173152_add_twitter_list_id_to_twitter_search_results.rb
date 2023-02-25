class AddTwitterListIdToTwitterSearchResults < ActiveRecord::Migration[7.0]
  def change
    add_column :twitter_search_results, :twitter_list_id, :string
  end
end
