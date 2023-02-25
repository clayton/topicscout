class CreateTwitterLists < ActiveRecord::Migration[7.0]
  def change
    create_table :twitter_lists, id: :uuid do |t|
      t.string :name
      t.string :description
      t.boolean :private
      t.string :twitter_list_id
      t.references :topic, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
