class AddTopicIdToUrls < ActiveRecord::Migration[7.0]
  def change
    add_column :urls, :topic_id, :uuid
    add_index :urls, :topic_id
  end
end
