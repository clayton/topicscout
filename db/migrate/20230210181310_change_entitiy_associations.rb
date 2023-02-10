class ChangeEntitiyAssociations < ActiveRecord::Migration[7.0]
  def change
    add_column :hashtags, :tweet_id, :uuid
    add_column :urls, :tweet_id, :uuid
  end
end
