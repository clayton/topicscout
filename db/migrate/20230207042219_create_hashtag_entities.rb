class CreateHashtagEntities < ActiveRecord::Migration[7.0]
  def change
    create_table :hashtag_entities, id: :uuid do |t|
      t.uuid :hashtag_id
      t.uuid :tweet_id
      t.uuid :topic_id

      t.index :topic_id

      t.timestamps
    end
  end
end
