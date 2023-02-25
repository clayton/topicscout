class AddTwitterListIdToTweets < ActiveRecord::Migration[7.0]
  def change
    add_column :tweets, :twitter_list_id, :string
  end
end
