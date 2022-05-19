class CreateSearchTerms < ActiveRecord::Migration[7.0]
  def change
    create_table :search_terms, id: :uuid do |t|
      t.references :topic, null: false, foreign_key: true, type: :uuid
      t.string :term

      t.timestamps
    end
  end
end
