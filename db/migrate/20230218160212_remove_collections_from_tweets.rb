class RemoveCollectionsFromTweets < ActiveRecord::Migration[7.0]
  def change
    remove_column :tweets, :collection_id
  end
end
