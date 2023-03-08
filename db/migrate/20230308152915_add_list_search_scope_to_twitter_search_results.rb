class AddListSearchScopeToTwitterSearchResults < ActiveRecord::Migration[7.0]
  def change
    add_column :twitter_search_results, :list_search, :boolean, default: false
  end
end
