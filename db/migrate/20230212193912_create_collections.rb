class CreateCollections < ActiveRecord::Migration[7.0]
  def change
    create_table :collections, id: :uuid do |t|
      t.string :name
      t.boolean :archived

      t.timestamps
    end
  end
end
