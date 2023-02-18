class RemoveForeignKeyCollectionsFromTweets < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :tweets, :collections
  end
end
