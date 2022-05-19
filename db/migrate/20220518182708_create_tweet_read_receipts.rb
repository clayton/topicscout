class CreateTweetReadReceipts < ActiveRecord::Migration[7.0]
  def change
    create_table :tweet_read_receipts, id: :uuid do |t|
      t.references :tweet, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :interest, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
