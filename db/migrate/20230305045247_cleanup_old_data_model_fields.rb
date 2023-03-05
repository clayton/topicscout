class CleanupOldDataModelFields < ActiveRecord::Migration[7.0]
  def change
    remove_column :tweets, :author_id, :string
    remove_column :tweets, :name, :string
    remove_column :tweets, :profile_image_url, :string
    remove_column :tweets, :username, :string

    remove_column :urls, :tweet_id, :uuid
    remove_column :urls, :url, :string
    remove_column :urls, :uri_hash, :string
  end
end
