class CreateCollectionCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :collection_categories, id: :uuid do |t|
      t.string :name
      t.references :collection, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
