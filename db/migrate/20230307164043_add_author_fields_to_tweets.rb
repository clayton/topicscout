class AddAuthorFieldsToTweets < ActiveRecord::Migration[7.0]
  def change
    add_column :tweets, :author_id, :string
    add_column :tweets, :author_name, :string
    add_column :tweets, :author_username, :string
    add_column :tweets, :author_profile_image_url, :string
  end
end
