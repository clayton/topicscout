class AddUrlHashToUrls < ActiveRecord::Migration[7.0]
  def change
    add_column :urls, :url_hash, :string
    add_index :urls, %i[url_hash topic_id]
  end
end
