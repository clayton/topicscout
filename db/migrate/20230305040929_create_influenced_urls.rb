class CreateInfluencedUrls < ActiveRecord::Migration[7.0]
  def change
    create_table :influenced_urls, id: :uuid do |t|
      t.references :influencer, null: false, foreign_key: true, type: :uuid
      t.references :url, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
