class CreateUrlEntities < ActiveRecord::Migration[7.0]
  def change
    create_table :url_entities, id: :uuid do |t|
      t.uuid :tweet_id
      t.uuid :url_id
      t.uuid :topic_id

      t.timestamps
    end
    add_index :url_entities, :tweet_id
    add_index :url_entities, :topic_id
  end
end
