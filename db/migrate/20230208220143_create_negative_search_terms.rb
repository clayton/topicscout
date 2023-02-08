class CreateNegativeSearchTerms < ActiveRecord::Migration[7.0]
  def change
    create_table :negative_search_terms, id: :uuid do |t|
      t.string :term
      t.uuid :topic_id

      t.timestamps
    end
  end
end
