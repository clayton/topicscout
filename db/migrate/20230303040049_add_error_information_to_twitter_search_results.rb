class AddErrorInformationToTwitterSearchResults < ActiveRecord::Migration[7.0]
  def change
    add_column :twitter_search_results, :errored, :boolean
    add_column :twitter_search_results, :error_message, :string
    add_column :twitter_search_results, :error_description, :text
  end
end
