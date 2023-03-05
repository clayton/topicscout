class CreateInfluencers < ActiveRecord::Migration[7.0]
  def change
    create_table :influencers, id: :uuid do |t|
      t.references :topic, null: false, foreign_key: true, type: :uuid
      t.string :name
      t.string :profile_image_url
      t.string :profile_url
      t.integer :influenced_count
      t.integer :saved_count
      t.integer :collected_count
      t.string :platform_id
      t.string :username
      t.string :platform

      t.timestamps
    end
  end
end
