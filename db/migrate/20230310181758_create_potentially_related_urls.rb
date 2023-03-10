class CreatePotentiallyRelatedUrls < ActiveRecord::Migration[7.0]
  def change
    create_table :potentially_related_urls, id: :uuid do |t|
      t.uuid :url_id
      t.uuid :topic_id
      t.uuid :related_url_id
      t.float :similarity

      t.timestamps
    end
    add_index :potentially_related_urls, :url_id
    add_index :potentially_related_urls, :topic_id
  end
end
