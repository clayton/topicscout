class AddBirderDetailsToTwitterSearchResults < ActiveRecord::Migration[7.0]
  def change
    add_column :twitter_search_results, :debug_description, :text
  end
end
